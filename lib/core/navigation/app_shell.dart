import 'package:flutter/material.dart';
import 'package:science_cup_app/core/presentation/widgets/auth_profile_button.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          AuthProfileButton()
        ],
      ),
      body: child,
    );
  }
}

