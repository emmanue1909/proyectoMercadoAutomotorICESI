import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AutoMarketApp());
}

class AutoMarketApp extends StatelessWidget {
  const AutoMarketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoMarket - Plataforma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
