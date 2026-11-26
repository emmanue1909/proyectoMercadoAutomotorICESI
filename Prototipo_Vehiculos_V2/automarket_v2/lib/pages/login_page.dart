import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController correoController;
  final TextEditingController contrasenaController;
  final bool cargando;
  final String? mensajeError;
  final VoidCallback onIniciarSesion;

  const LoginPage({
    Key? key,
    required this.correoController,
    required this.contrasenaController,
    required this.onIniciarSesion,
    this.cargando = false,
    this.mensajeError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AppCard(
            elevation: 4,
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2041).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 52,
                      color: Color(0xFF0F2041),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'AutoMarket V2',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2041),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Plataforma Inteligente de Vehículos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: 'Correo',
                    controller: correoController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Contraseña',
                    controller: contrasenaController,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    onFieldSubmitted: (_) => onIniciarSesion(),
                  ),
                  if (mensajeError != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      mensajeError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                    ),
                  ],
                  const SizedBox(height: 20),
                  AppButton(
                    label: cargando ? 'Ingresando…' : 'Iniciar sesión',
                    isLoading: cargando,
                    isFullWidth: true,
                    onPressed: onIniciarSesion,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
