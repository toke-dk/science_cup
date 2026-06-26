import 'package:flutter/material.dart';
import 'package:science_cup_app/features/auth/presentation/widgets/email_login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log ind')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: EmailLoginForm()),
      ),
    );
  }
}
