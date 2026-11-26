import 'dart:async';

import 'package:automarket_v2/services/auth_service.dart';

const String correoPrueba = 'persona@ejemplo.com';
const String contrasenaPrueba = 'clave-de-prueba';
const String idPrueba = 'uuid-de-prueba';

/// Fila válida de `usuarios`. Cada prueba quita o cambia lo que necesita.
Map<String, dynamic> filaPrueba({String rol = 'empleado', bool activo = true}) {
  return {
    'id': idPrueba,
    'nombre': 'Persona de Prueba',
    'correo': correoPrueba,
    'rol': rol,
    'activo': activo,
  };
}

/// Backend en memoria para probar sin red ni Supabase. Solo para pruebas.
class FakeAuthBackend implements AuthBackend {
  FakeAuthBackend({this.fila, this.idSesion});

  /// `null` simula una cuenta sin fila en `usuarios`.
  Map<String, dynamic>? fila;

  /// Sesión abierta en el proveedor; `null` si no hay.
  String? idSesion;

  /// Errores que se lanzan en cada operación cuando no son `null`.
  Object? errorAlIniciar;
  Object? errorAlLeerFila;
  Object? errorAlCerrar;
  Object? errorAlConsultarSesion;

  /// Simula un cierre que borra la sesión y aun así lanza [errorAlCerrar].
  bool cierraAunqueFalle = false;

  /// Si no son `null`, la operación espera a que se completen.
  Completer<void>? esperaAlIniciar;
  Completer<void>? esperaAlLeerFila;
  Completer<void>? esperaAlCerrar;

  int intentosDeInicio = 0;
  int cierres = 0;

  @override
  Future<String> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    intentosDeInicio++;
    await esperaAlIniciar?.future;
    if (errorAlIniciar != null) throw errorAlIniciar!;
    if (correo != correoPrueba || contrasena != contrasenaPrueba) {
      throw const ErrorAutenticacion(TipoErrorAuth.credencialesIncorrectas);
    }
    idSesion = idPrueba;
    return idPrueba;
  }

  @override
  Future<Map<String, dynamic>?> obtenerFilaUsuario(String id) async {
    await esperaAlLeerFila?.future;
    if (errorAlLeerFila != null) throw errorAlLeerFila!;
    return fila;
  }

  @override
  Future<String?> idSesionActual() async {
    if (errorAlConsultarSesion != null) throw errorAlConsultarSesion!;
    return idSesion;
  }

  @override
  Future<void> cerrarSesion() async {
    cierres++;
    await esperaAlCerrar?.future;
    if (errorAlCerrar != null) {
      if (cierraAunqueFalle) idSesion = null;
      throw errorAlCerrar!;
    }
    idSesion = null;
  }
}
