import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import 'admin_screen.dart';
import 'employee_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      onLoginAsEmployee: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeScreen()),
        );
      },
      onLoginAsAdmin: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminScreen()),
        );
      },
    );
  }
}
