import 'dart:async';

import 'package:automarket_v2/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_auth_backend.dart';

Matcher fallaCon(TipoErrorAuth tipo) => throwsA(
      isA<ErrorAutenticacion>().having((e) => e.tipo, 'tipo', tipo),
    );

void main() {
  late FakeAuthBackend backend;
  late AuthService auth;
  late List<EstadoSesion> cambios;

  setUp(() {
    backend = FakeAuthBackend(fila: filaPrueba());
    auth = AuthService.conBackend(backend);
    cambios = [];
    auth.cambiosSesion.listen(cambios.add);
  });

  Future<void> entrar({String contrasena = contrasenaPrueba}) =>
      auth.iniciarSesion(correo: correoPrueba, contrasena: contrasena);

  void esperarSinAcceso() {
    expect(auth.estadoSesion, EstadoSesion.sinSesion);
    expect(auth.usuarioActual, isNull);
    expect(auth.rolActual, isNull);
  }

  group('Sesión inicial e instancia', () {
    test('no hay sesión inicial aunque el proveedor tenga una abierta', () {
      // Recuperar una sesión es parte de C3: sin validarla no se da acceso.
      auth = AuthService.conBackend(
        FakeAuthBackend(fila: filaPrueba(), idSesion: idPrueba),
      );
      esperarSinAcceso();
    });

    test('AuthService() devuelve siempre la misma instancia', () {
      expect(identical(AuthService(), AuthService()), isTrue);
    });

    test('el backend por defecto no da acceso', () async {
      await expectLater(
        AuthService().iniciarSesion(
          correo: correoPrueba,
          contrasena: contrasenaPrueba,
        ),
        fallaCon(TipoErrorAuth.inesperado),
      );
      expect(AuthService().estadoSesion, EstadoSesion.sinSesion);
      expect(AuthService().usuarioActual, isNull);
    });
  });

  group('Inicio de sesión', () {
    test('CA-1: un empleado activo queda autenticado con su rol', () async {
      await entrar();
      await pumpEventQueue();

      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(auth.rolActual, RolUsuario.empleado);
      expect(auth.usuarioActual?.id, idPrueba);
      expect(auth.usuarioActual?.correo, correoPrueba);
      expect(cambios, [EstadoSesion.autenticado]);
    });

    test('CA-2: un administrador activo queda autenticado con su rol', () async {
      backend.fila = filaPrueba(rol: 'administrador');
      await entrar();
      expect(auth.rolActual, RolUsuario.administrador);
    });

    test('no publica «autenticado» antes de validar la fila', () async {
      backend.esperaAlLeerFila = Completer<void>();
      final envio = entrar();
      await pumpEventQueue();

      expect(backend.idSesion, idPrueba, reason: 'Auth ya abrió la sesión');
      expect(cambios, isEmpty);
      esperarSinAcceso();

      backend.esperaAlLeerFila!.complete();
      await envio;
      await pumpEventQueue();
      expect(cambios, [EstadoSesion.autenticado]);
    });

    test('CA-3: con credenciales incorrectas no hay acceso', () async {
      await expectLater(
        entrar(contrasena: 'otra'),
        fallaCon(TipoErrorAuth.credencialesIncorrectas),
      );
      await pumpEventQueue();
      esperarSinAcceso();
      expect(cambios, isEmpty);
    });

    test('CA-4: una cuenta inactiva no entra y se cierra su sesión', () async {
      backend.fila = filaPrueba(activo: false);
      await expectLater(entrar(), fallaCon(TipoErrorAuth.cuentaDesactivada));
      await pumpEventQueue();

      esperarSinAcceso();
      expect(cambios, isEmpty);
      expect(backend.cierres, 1);
      expect(backend.idSesion, isNull);
    });

    test('sigue sin acceso si además falla el cierre al descartar', () async {
      backend.fila = filaPrueba(activo: false);
      backend.errorAlCerrar = Exception('sin red');
      await expectLater(entrar(), fallaCon(TipoErrorAuth.cuentaDesactivada));
      esperarSinAcceso();
    });
  });

  group('Fila de usuario no válida (sin acceso por defecto)', () {
    final casos = <String, Map<String, dynamic>? Function()>{
      'sin fila': () => null,
      'fila vacía': () => <String, dynamic>{},
      'sin id': () => filaPrueba()..remove('id'),
      'id de otra cuenta': () => filaPrueba()..['id'] = 'otro-uuid',
      'sin activo': () => filaPrueba()..remove('activo'),
      'activo nulo': () => filaPrueba()..['activo'] = null,
      'activo como texto': () => filaPrueba()..['activo'] = 'true',
      'sin rol': () => filaPrueba()..remove('rol'),
      'rol nulo': () => filaPrueba()..['rol'] = null,
      'rol vacío': () => filaPrueba(rol: ''),
      'rol desconocido': () => filaPrueba(rol: 'Particular'),
      'rol con otra capitalización (D-1)': () => filaPrueba(rol: 'Empleado'),
      'rol que no es texto': () => filaPrueba()..['rol'] = 1,
    };

    casos.forEach((nombre, crearFila) {
      test(nombre, () async {
        backend.fila = crearFila();
        await expectLater(entrar(), fallaCon(TipoErrorAuth.sinAcceso));
        await pumpEventQueue();

        esperarSinAcceso();
        expect(cambios, isEmpty);
        expect(backend.idSesion, isNull);
      });
    });
  });

  group('Errores del backend', () {
    test('CA-8: la falta de conexión al autenticar se informa', () async {
      backend.errorAlIniciar =
          const ErrorAutenticacion(TipoErrorAuth.sinConexion);
      await expectLater(entrar(), fallaCon(TipoErrorAuth.sinConexion));
      esperarSinAcceso();
    });

    test('sin conexión al leer la fila: se descarta la sesión', () async {
      backend.errorAlLeerFila =
          const ErrorAutenticacion(TipoErrorAuth.sinConexion);
      await expectLater(entrar(), fallaCon(TipoErrorAuth.sinConexion));
      esperarSinAcceso();
      expect(backend.idSesion, isNull);
    });

    test('una excepción desconocida al autenticar es «inesperado»', () async {
      backend.errorAlIniciar = Exception('detalle técnico');
      await expectLater(entrar(), fallaCon(TipoErrorAuth.inesperado));
      esperarSinAcceso();
    });

    test('un fallo desconocido al leer la fila es «inesperado»', () async {
      backend.errorAlLeerFila = StateError('detalle técnico');
      await expectLater(entrar(), fallaCon(TipoErrorAuth.inesperado));
      esperarSinAcceso();
      expect(backend.idSesion, isNull);
    });

    test('se puede entrar al reintentar después de un fallo', () async {
      backend.errorAlIniciar =
          const ErrorAutenticacion(TipoErrorAuth.sinConexion);
      await expectLater(entrar(), fallaCon(TipoErrorAuth.sinConexion));

      backend.errorAlIniciar = null;
      await entrar();
      expect(auth.estadoSesion, EstadoSesion.autenticado);
    });
  });

  group('Carreras entre inicio y cierre de sesión', () {
    /// Inicia el envío y absorbe su error: aquí se comprueba el estado.
    Future<void> entrarSinPropagar() => entrar().catchError((Object _) {});

    void esperarNuncaAutenticado() {
      esperarSinAcceso();
      expect(cambios, isEmpty);
      expect(backend.idSesion, isNull, reason: 'sesión viva en el proveedor');
    }

    test('cierre pedido mientras Auth responde', () async {
      final espera = backend.esperaAlIniciar = Completer<void>();
      final envio = entrarSinPropagar();
      await pumpEventQueue();

      final cierre = auth.cerrarSesion();
      await pumpEventQueue();
      espera.complete();
      await Future.wait([envio, cierre]);
      await pumpEventQueue();

      esperarNuncaAutenticado();
    });

    test('cierre pedido mientras se lee la fila', () async {
      final espera = backend.esperaAlLeerFila = Completer<void>();
      final envio = entrarSinPropagar();
      await pumpEventQueue();

      final cierre = auth.cerrarSesion();
      await pumpEventQueue();
      espera.complete();
      await Future.wait([envio, cierre]);
      await pumpEventQueue();

      esperarNuncaAutenticado();
    });

    test('un cierre lento no afecta al inicio pedido después', () async {
      await entrar();
      final espera = backend.esperaAlCerrar = Completer<void>();
      final cierre = auth.cerrarSesion();
      await pumpEventQueue();

      final envio = entrar();
      await pumpEventQueue();
      espera.complete();
      await Future.wait([cierre, envio]);

      // La última petición fue entrar: servicio y proveedor deben coincidir.
      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(backend.idSesion, idPrueba);
    });

    test('el inicio cancelado falla con «cancelado»', () async {
      final espera = backend.esperaAlLeerFila = Completer<void>();
      final envio = expectLater(entrar(), fallaCon(TipoErrorAuth.cancelado));
      await pumpEventQueue();

      final cierre = auth.cerrarSesion();
      espera.complete();
      await Future.wait([envio, cierre]);
    });

    test('un inicio que aún espera turno se cancela sin llamar al backend',
        () async {
      final espera = backend.esperaAlIniciar = Completer<void>();
      final primero = entrarSinPropagar();
      final segundo = expectLater(entrar(), fallaCon(TipoErrorAuth.cancelado));
      await pumpEventQueue();

      final cierre = auth.cerrarSesion();
      espera.complete();
      await Future.wait([primero, segundo, cierre]);
      await pumpEventQueue();

      expect(backend.intentosDeInicio, 1);
      esperarNuncaAutenticado();
    });

    test('si además falla el cierre, el inicio cancelado no da acceso',
        () async {
      final espera = backend.esperaAlIniciar = Completer<void>();
      backend.errorAlCerrar =
          const ErrorAutenticacion(TipoErrorAuth.sinConexion);
      final envio = entrarSinPropagar();
      await pumpEventQueue();

      final cierre = expectLater(
        auth.cerrarSesion(),
        fallaCon(TipoErrorAuth.sinConexion),
      );
      espera.complete();
      await Future.wait([envio, cierre]);
      await pumpEventQueue();

      // El proveedor pudo quedar con sesión, pero el servicio no da acceso.
      esperarSinAcceso();
      expect(cambios, isEmpty);
      expect(backend.idSesion, idPrueba);
    });

    test('dos inicios no se cruzan: el segundo espera al primero', () async {
      final espera = backend.esperaAlIniciar = Completer<void>();
      final primero = expectLater(
        entrar(contrasena: 'otra'),
        fallaCon(TipoErrorAuth.credencialesIncorrectas),
      );
      final segundo = entrar();
      await pumpEventQueue();
      expect(backend.intentosDeInicio, 1);

      espera.complete();
      await Future.wait([primero, segundo]);

      expect(backend.intentosDeInicio, 2);
      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(backend.idSesion, idPrueba);
    });

    test('después de una cancelación se puede volver a entrar', () async {
      final espera = backend.esperaAlIniciar = Completer<void>();
      final envio = entrarSinPropagar();
      final cierre = auth.cerrarSesion();
      espera.complete();
      await Future.wait([envio, cierre]);

      await entrar();
      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(backend.idSesion, idPrueba);
    });

    /// «ok» o el nombre del [TipoErrorAuth] con el que terminó la operación.
    Future<String> resultado(Future<void> operacion) => operacion.then(
          (_) => 'ok',
          onError: (Object error) => (error as ErrorAutenticacion).tipo.name,
        );

    test('inicio pendiente, cierre y nuevo inicio: solo entra el último',
        () async {
      // El primero se detiene cuando Auth ya abrió su sesión.
      final espera = backend.esperaAlLeerFila = Completer<void>();
      final primero = resultado(entrar());
      await pumpEventQueue();
      expect(backend.idSesion, idPrueba);

      final cierre = resultado(auth.cerrarSesion());
      final ultimo = resultado(entrar());
      await pumpEventQueue();
      expect(backend.intentosDeInicio, 1, reason: 'el último espera turno');

      espera.complete();
      expect(
        await Future.wait([primero, cierre, ultimo]),
        ['cancelado', 'ok', 'ok'],
      );
      await pumpEventQueue();

      expect(backend.intentosDeInicio, 2);
      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(auth.rolActual, RolUsuario.empleado);
      expect(backend.idSesion, idPrueba);
      expect(cambios, [EstadoSesion.autenticado]);
    });

    test('un inicio en espera detrás de un cierre fallido se completa',
        () async {
      await entrar();
      await pumpEventQueue();
      cambios.clear();

      final espera = backend.esperaAlCerrar = Completer<void>();
      backend.errorAlCerrar =
          const ErrorAutenticacion(TipoErrorAuth.sinConexion);
      final cierre = resultado(auth.cerrarSesion());
      // El rol nuevo permite comprobar que este inicio sí se aplicó.
      backend.fila = filaPrueba(rol: 'administrador');
      final envio = resultado(entrar());
      await pumpEventQueue();
      expect(backend.intentosDeInicio, 1, reason: 'el nuevo espera turno');

      espera.complete();
      expect(await Future.wait([cierre, envio]), ['sinConexion', 'ok']);
      await pumpEventQueue();

      expect(backend.intentosDeInicio, 2);
      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(auth.rolActual, RolUsuario.administrador);
      expect(backend.idSesion, idPrueba);
      // Nunca pasó por «sin sesión», porque el cierre no se completó.
      expect(cambios, [EstadoSesion.autenticado]);
    });

    test('inicios y cierres intercalados respetan el orden pedido', () async {
      final espera = backend.esperaAlIniciar = Completer<void>();
      final terminadas = <String>[];
      Future<String> anotar(String nombre, Future<void> operacion) =>
          resultado(operacion).whenComplete(() => terminadas.add(nombre));

      final operaciones = [
        anotar('inicio 1', entrar()),
        anotar('cierre 1', auth.cerrarSesion()),
        anotar('inicio 2', entrar()),
        anotar('cierre 2', auth.cerrarSesion()),
        anotar('inicio 3', entrar()),
      ];
      await pumpEventQueue();
      expect(terminadas, isEmpty);

      espera.complete();
      expect(
        await Future.wait(operaciones),
        ['cancelado', 'ok', 'cancelado', 'ok', 'ok'],
      );
      await pumpEventQueue();

      expect(terminadas, [
        'inicio 1',
        'cierre 1',
        'inicio 2',
        'cierre 2',
        'inicio 3',
      ]);
      expect(backend.intentosDeInicio, 2, reason: 'el 2 no llega al backend');
      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(backend.idSesion, idPrueba);
      expect(cambios, [EstadoSesion.autenticado]);
    });
  });

  group('Cierre de sesión', () {
    setUp(() async {
      await entrar();
      await pumpEventQueue();
      cambios.clear();
    });

    test('CA-6: deja el servicio sin sesión y lo avisa', () async {
      await auth.cerrarSesion();
      await pumpEventQueue();

      esperarSinAcceso();
      expect(backend.idSesion, isNull);
      expect(cambios, [EstadoSesion.sinSesion]);
    });

    test('cerrar dos veces no repite el aviso', () async {
      await auth.cerrarSesion();
      await auth.cerrarSesion();
      await pumpEventQueue();
      expect(cambios, [EstadoSesion.sinSesion]);
    });

    test('permite entrar otra vez, incluso con otro rol', () async {
      await auth.cerrarSesion();
      backend.fila = filaPrueba(rol: 'administrador');
      await entrar();
      expect(auth.rolActual, RolUsuario.administrador);
    });

    test('si falla y la sesión sigue abierta, la conserva', () async {
      backend.errorAlCerrar =
          const ErrorAutenticacion(TipoErrorAuth.sinConexion);
      await expectLater(
        auth.cerrarSesion(),
        fallaCon(TipoErrorAuth.sinConexion),
      );
      await pumpEventQueue();

      expect(auth.estadoSesion, EstadoSesion.autenticado);
      expect(auth.rolActual, RolUsuario.empleado);
      expect(cambios, isEmpty);
    });

    test('si falla y no se puede comprobar, conserva la sesión', () async {
      backend.errorAlCerrar = Exception('falló el cierre');
      backend.errorAlConsultarSesion = Exception('falló la consulta');
      await expectLater(
        auth.cerrarSesion(),
        fallaCon(TipoErrorAuth.inesperado),
      );
      expect(auth.estadoSesion, EstadoSesion.autenticado);
    });

    test('si falla pero la sesión ya no existe, queda sin sesión', () async {
      backend.errorAlCerrar = Exception('falló el aviso al servidor');
      backend.cierraAunqueFalle = true;
      await auth.cerrarSesion();
      await pumpEventQueue();

      esperarSinAcceso();
      expect(cambios, [EstadoSesion.sinSesion]);
    });

    test('un reingreso rechazado no conserva la sesión anterior', () async {
      backend.fila = filaPrueba(activo: false);
      await expectLater(entrar(), fallaCon(TipoErrorAuth.cuentaDesactivada));
      await pumpEventQueue();

      esperarSinAcceso();
      expect(cambios, [EstadoSesion.sinSesion]);
    });
  });
}
