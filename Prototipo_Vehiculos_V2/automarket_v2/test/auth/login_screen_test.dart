import 'dart:async';

import 'package:automarket_v2/screens/login_screen.dart';
import 'package:automarket_v2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_auth_backend.dart';

void main() {
  late FakeAuthBackend backend;
  late AuthService auth;

  setUp(() {
    backend = FakeAuthBackend(fila: filaPrueba());
    auth = AuthService.conBackend(backend);
  });

  final campoCorreo = find.widgetWithText(TextFormField, 'Correo');
  final campoContrasena = find.widgetWithText(TextFormField, 'Contraseña');

  Future<void> abrir(WidgetTester tester) =>
      tester.pumpWidget(MaterialApp(home: LoginScreen(auth: auth)));

  Future<void> llenar(
    WidgetTester tester, {
    String contrasena = contrasenaPrueba,
  }) async {
    await tester.enterText(campoCorreo, correoPrueba);
    await tester.enterText(campoContrasena, contrasena);
  }

  Future<void> enviar(WidgetTester tester) async {
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump();
  }

  String textoDe(WidgetTester tester, Finder campo) => tester
      .widget<EditableText>(
        find.descendant(of: campo, matching: find.byType(EditableText)),
      )
      .controller
      .text;

  testWidgets('muestra correo y contraseña, sin roles ni registro',
      (tester) async {
    await abrir(tester);

    expect(campoCorreo, findsOneWidget);
    expect(campoContrasena, findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    expect(find.textContaining('Ingresar como'), findsNothing);
    expect(find.textContaining('Regist'), findsNothing);
    expect(find.textContaining('Olvid'), findsNothing);
  });

  testWidgets('la contraseña no se ve mientras se escribe', (tester) async {
    await abrir(tester);
    final editable = tester.widget<EditableText>(
      find.descendant(
        of: campoContrasena,
        matching: find.byType(EditableText),
      ),
    );
    expect(editable.obscureText, isTrue);
  });

  testWidgets('muestra «Ingresando…» y no admite un segundo envío',
      (tester) async {
    backend.esperaAlIniciar = Completer<void>();
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    expect(find.text('Ingresando…'), findsOneWidget);
    final boton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(boton.onPressed, isNull);

    // Ni el botón ni la tecla de envío del teclado repiten la llamada.
    await tester.tap(find.byType(ElevatedButton));
    await tester.showKeyboard(campoContrasena);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(backend.intentosDeInicio, 1);

    backend.esperaAlIniciar!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('CA-1: con datos correctos autentica sin mostrar errores',
      (tester) async {
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    expect(auth.estadoSesion, EstadoSesion.autenticado);
    expect(find.textContaining('No se pudo'), findsNothing);
    // Cambiar de pantalla es tarea de AppGate (C3).
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('CA-3: avisa credenciales incorrectas y permite reintentar',
      (tester) async {
    await abrir(tester);
    await llenar(tester, contrasena: 'otra');
    await enviar(tester);

    expect(find.text('Correo o contraseña incorrectos'), findsOneWidget);
    expect(auth.estadoSesion, EstadoSesion.sinSesion);

    await llenar(tester);
    await enviar(tester);
    expect(find.text('Correo o contraseña incorrectos'), findsNothing);
    expect(auth.estadoSesion, EstadoSesion.autenticado);
  });

  testWidgets('CA-4: avisa que la cuenta está desactivada', (tester) async {
    backend.fila = filaPrueba(activo: false);
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    expect(find.text('Tu cuenta está desactivada'), findsOneWidget);
  });

  testWidgets('CA-8: sin conexión avisa y conserva el correo', (tester) async {
    backend.errorAlIniciar =
        const ErrorAutenticacion(TipoErrorAuth.sinConexion);
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    expect(
      find.text(
        'No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo',
      ),
      findsOneWidget,
    );
    expect(textoDe(tester, campoCorreo), correoPrueba);
  });

  testWidgets('no muestra errores técnicos (mensaje provisional, D-6)',
      (tester) async {
    backend.errorAlIniciar = Exception('detalle técnico');
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    expect(find.text('No se pudo iniciar sesión'), findsOneWidget);
    expect(find.textContaining('detalle técnico'), findsNothing);
  });

  testWidgets('no valida la longitud de la contraseña', (tester) async {
    await abrir(tester);
    await llenar(tester, contrasena: '1');
    await enviar(tester);
    expect(backend.intentosDeInicio, 1);
  });

  testWidgets('un envío cancelado por un cierre no muestra error',
      (tester) async {
    backend.esperaAlIniciar = Completer<void>();
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    final cierre = auth.cerrarSesion();
    backend.esperaAlIniciar!.complete();
    await tester.pumpAndSettle();
    await cierre;

    expect(auth.estadoSesion, EstadoSesion.sinSesion);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.textContaining('No se pudo'), findsNothing);
  });

  testWidgets('no falla si la pantalla se retira durante el envío',
      (tester) async {
    backend.esperaAlIniciar = Completer<void>();
    await abrir(tester);
    await llenar(tester);
    await enviar(tester);

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    backend.esperaAlIniciar!.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('RNF-02: no se desborda a 360 px, tampoco con un error',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    backend.errorAlIniciar =
        const ErrorAutenticacion(TipoErrorAuth.sinConexion);

    await abrir(tester);
    expect(tester.takeException(), isNull);

    await llenar(tester);
    await tester.ensureVisible(find.byType(ElevatedButton));
    await enviar(tester);
    expect(find.textContaining('Revisa tu conexión'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
