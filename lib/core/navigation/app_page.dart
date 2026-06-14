import 'package:flutter/material.dart';
import 'package:science_cup_app/core/presentation/widgets/auth_profile_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Velkommen til SCIENCEcup"),
        centerTitle: false,
        actions: [
          AuthProfileButton()
        ],
      ),
      body: child,
    );
  }
}

