// lib/features/auth/presentation/login_page.dart
import 'package:flutter/material.dart';
import 'widgets/phone_login_form.dart'; // Importér den herfra

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log ind')),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: PhoneLoginForm(), // <-- Smidt direkte ind i midten af skærmen
        ),
      ),
    );
  }
}