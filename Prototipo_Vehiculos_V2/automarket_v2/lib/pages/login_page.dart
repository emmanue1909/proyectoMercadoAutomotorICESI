import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onLoginAsEmployee;
  final VoidCallback onLoginAsAdmin;

  const LoginPage({
    Key? key,
    required this.onLoginAsEmployee,
    required this.onLoginAsAdmin,
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Ingresar como Empleado',
                    icon: Icons.person_outline,
                    variant: AppButtonVariant.primary,
                    isFullWidth: true,
                    onPressed: onLoginAsEmployee,
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    label: 'Ingresar como Administrador',
                    icon: Icons.admin_panel_settings_outlined,
                    variant: AppButtonVariant.outlined,
                    isFullWidth: true,
                    onPressed: onLoginAsAdmin,
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
