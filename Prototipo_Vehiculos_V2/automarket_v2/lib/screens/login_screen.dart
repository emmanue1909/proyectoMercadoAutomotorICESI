import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  /// Si no se entrega, usa la instancia compartida de [AuthService].
  final AuthService? auth;

  const LoginScreen({Key? key, this.auth}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// PROVISIONAL (decisión D-6): las specs no definen mensaje para una cuenta
  /// sin acceso ni para errores inesperados. Este no atribuye una causa.
  static const String _mensajeSinDefinir = 'No se pudo iniciar sesión';

  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _cargando = false;
  String? _mensajeError;

  AuthService get _auth => widget.auth ?? AuthService();

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (_cargando) return;
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    String? mensaje;
    try {
      await _auth.iniciarSesion(
        correo: _correoController.text,
        contrasena: _contrasenaController.text,
      );
    } on ErrorAutenticacion catch (error) {
      mensaje = _mensajeDe(error.tipo);
    }

    if (!mounted) return;
    setState(() {
      _cargando = false;
      _mensajeError = mensaje;
    });
  }

  /// `null` significa que no hay nada que avisar.
  String? _mensajeDe(TipoErrorAuth tipo) {
    switch (tipo) {
      case TipoErrorAuth.credencialesIncorrectas:
        return 'Correo o contraseña incorrectos';
      case TipoErrorAuth.cuentaDesactivada:
        return 'Tu cuenta está desactivada';
      case TipoErrorAuth.sinConexion:
        return 'No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo';
      case TipoErrorAuth.cancelado:
        return null;
      case TipoErrorAuth.sinAcceso:
      case TipoErrorAuth.inesperado:
        return _mensajeSinDefinir;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      correoController: _correoController,
      contrasenaController: _contrasenaController,
      cargando: _cargando,
      mensajeError: _mensajeError,
      onIniciarSesion: _iniciarSesion,
    );
  }
}
