import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/usuario.dart';

/// Roles que dan acceso a la aplicación.
enum RolUsuario { empleado, administrador }

/// Único punto donde el texto del rol se convierte en [RolUsuario].
///
/// PROVISIONAL (decisión D-1): usa los valores del contrato del reparto.
/// Cualquier otro valor, incluso con otras mayúsculas, no da acceso.
RolUsuario? _rolDesdeTexto(Object? valor) {
  switch (valor) {
    case 'empleado':
      return RolUsuario.empleado;
    case 'administrador':
      return RolUsuario.administrador;
    default:
      return null;
  }
}

enum EstadoSesion { sinSesion, autenticado }

enum TipoErrorAuth {
  credencialesIncorrectas,
  cuentaDesactivada,
  sinConexion,

  /// La cuenta se autenticó, pero su fila de usuario no permite darle acceso.
  sinAcceso,

  /// Se pidió cerrar sesión antes de que el inicio terminara.
  cancelado,
  inesperado,
}

class ErrorAutenticacion implements Exception {
  final TipoErrorAuth tipo;

  const ErrorAutenticacion(this.tipo);

  @override
  String toString() => 'ErrorAutenticacion(${tipo.name})';
}

/// Acceso al proveedor de autenticación y a la tabla de usuarios.
///
/// Las implementaciones informan los fallos conocidos con
/// [ErrorAutenticacion]. Cualquier otra excepción se trata como inesperada.
abstract class AuthBackend {
  /// Abre una sesión y devuelve el `uuid` del usuario autenticado.
  Future<String> iniciarSesion({
    required String correo,
    required String contrasena,
  });

  /// Fila sin transformar de `usuarios` para [id], o `null` si no existe.
  Future<Map<String, dynamic>?> obtenerFilaUsuario(String id);

  /// `uuid` de la sesión que el proveedor tiene abierta, o `null`.
  Future<String?> idSesionActual();

  Future<void> cerrarSesion();
}

/// Backend usado mientras no exista la integración real. Nunca da acceso.
class _BackendSinConfigurar implements AuthBackend {
  const _BackendSinConfigurar();

  @override
  Future<String> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    throw const ErrorAutenticacion(TipoErrorAuth.inesperado);
  }

  @override
  Future<Map<String, dynamic>?> obtenerFilaUsuario(String id) async => null;

  @override
  Future<String?> idSesionActual() async => null;

  @override
  Future<void> cerrarSesion() async {}
}

/// Sesión de la aplicación. Solo hay usuario cuando su fila fue validada.
class AuthService {
  static final AuthService _instance =
      AuthService._(const _BackendSinConfigurar());
  factory AuthService() => _instance;
  AuthService._(this._backend);

  @visibleForTesting
  AuthService.conBackend(AuthBackend backend) : this._(backend);

  final AuthBackend _backend;
  final StreamController<EstadoSesion> _cambios =
      StreamController<EstadoSesion>.broadcast();

  Usuario? _usuario;
  RolUsuario? _rol;

  /// Final del último turno pedido; `null` si no hay operaciones en curso.
  Future<void>? _ultimoTurno;

  /// Aumenta con cada cierre pedido, aunque todavía espere su turno.
  int _cierresPedidos = 0;

  Usuario? get usuarioActual => _usuario;
  RolUsuario? get rolActual => _rol;

  EstadoSesion get estadoSesion =>
      _usuario == null ? EstadoSesion.sinSesion : EstadoSesion.autenticado;

  /// Avisa cada cambio de sesión. No repite el estado actual al suscribirse;
  /// para eso está [estadoSesion].
  Stream<EstadoSesion> get cambiosSesion => _cambios.stream;

  /// Lanza [ErrorAutenticacion] si no se puede dar acceso. Si después de
  /// esta llamada se pide cerrar sesión, nunca llega a «autenticado» y falla
  /// con [TipoErrorAuth.cancelado] o con el error que haya ocurrido antes.
  Future<void> iniciarSesion({
    required String correo,
    required String contrasena,
  }) {
    final cierresAlPedir = _cierresPedidos;
    void comprobarVigencia() {
      if (_cierresPedidos != cierresAlPedir) {
        throw const ErrorAutenticacion(TipoErrorAuth.cancelado);
      }
    }

    return _enTurno(
      () => _autenticar(correo, contrasena, comprobarVigencia),
    );
  }

  /// Si el proveedor falla y la sesión sigue abierta, o no se puede
  /// comprobar, conserva la sesión y lanza [ErrorAutenticacion].
  ///
  /// Cancela los inicios pedidos antes y espera a que terminen.
  Future<void> cerrarSesion() {
    _cierresPedidos++;
    return _enTurno(_cerrar);
  }

  /// Ejecuta las operaciones de a una y en el orden en que se pidieron, para
  /// que una no cambie la sesión del proveedor mientras otra está a medias.
  Future<void> _enTurno(Future<void> Function() operacion) async {
    final anterior = _ultimoTurno;
    final turno = Completer<void>();
    _ultimoTurno = turno.future;
    if (anterior != null) await anterior;
    try {
      await operacion();
    } finally {
      // El turno se libera también cuando la operación falla.
      if (identical(_ultimoTurno, turno.future)) _ultimoTurno = null;
      turno.complete();
    }
  }

  Future<void> _autenticar(
    String correo,
    String contrasena,
    void Function() comprobarVigencia,
  ) async {
    comprobarVigencia();

    final String id;
    try {
      id = await _backend.iniciarSesion(
        correo: correo,
        contrasena: contrasena,
      );
    } catch (error) {
      throw _comoErrorAutenticacion(error);
    }

    // El proveedor ya abrió una sesión: si algo falla desde aquí, se descarta.
    try {
      final fila = await _backend.obtenerFilaUsuario(id);
      final (usuario, rol) = _validarFila(id, fila);
      // Sin ningún `await` entre esta comprobación y la publicación.
      comprobarVigencia();
      _publicar(usuario, rol);
    } catch (error) {
      await _descartarSesion();
      throw _comoErrorAutenticacion(error);
    }
  }

  Future<void> _cerrar() async {
    try {
      await _backend.cerrarSesion();
    } catch (error) {
      if (await _sigueAbierta()) throw _comoErrorAutenticacion(error);
    }
    _publicar(null, null);
  }

  /// Se valida la fila antes de usar [Usuario.fromMap], porque ese
  /// constructor asume un empleado activo cuando faltan `rol` o `activo`.
  (Usuario, RolUsuario) _validarFila(String id, Map<String, dynamic>? fila) {
    if (fila == null || id.isEmpty || fila['id'] != id) {
      throw const ErrorAutenticacion(TipoErrorAuth.sinAcceso);
    }
    final activo = fila['activo'];
    if (activo == false) {
      throw const ErrorAutenticacion(TipoErrorAuth.cuentaDesactivada);
    }
    final rol = _rolDesdeTexto(fila['rol']);
    if (activo != true || rol == null) {
      throw const ErrorAutenticacion(TipoErrorAuth.sinAcceso);
    }
    return (Usuario.fromMap(fila), rol);
  }

  Future<bool> _sigueAbierta() async {
    try {
      return await _backend.idSesionActual() != null;
    } catch (_) {
      return true;
    }
  }

  Future<void> _descartarSesion() async {
    try {
      await _backend.cerrarSesion();
    } catch (_) {
      // Se informa el error original; la aplicación queda sin acceso.
    }
    _publicar(null, null);
  }

  void _publicar(Usuario? usuario, RolUsuario? rol) {
    if (usuario == null && _usuario == null) return;
    _usuario = usuario;
    _rol = rol;
    _cambios.add(estadoSesion);
  }

  ErrorAutenticacion _comoErrorAutenticacion(Object error) =>
      error is ErrorAutenticacion
          ? error
          : const ErrorAutenticacion(TipoErrorAuth.inesperado);
}
