import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthProfileButton extends StatelessWidget {
  const AuthProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {
      context.go('/login');
    }, icon: Icon(Icons.person));
  }
}
