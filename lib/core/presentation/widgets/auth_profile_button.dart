import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/auth/business_logic/auth_notifier.dart';

class AuthProfileButton extends StatelessWidget {
  const AuthProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<AuthNotifier>().profile;

    if (profile == null) {
      return IntrinsicWidth(
        child: ListTile(
          leading: IconButton(
            onPressed: () {
              context.go('/login');
            },
            icon: Icon(Icons.person),
          ),
          title: Text("Login"),
        ),
      );
    } else {
      return IntrinsicWidth(
        child: ListTile(
          leading: IconButton(
            onPressed: () async {
              await context.read<AuthNotifier>().signOut();
            },
            icon: Icon(Icons.person),
          ),
          title: Text("${profile.email}"),
        ),
      );
    }
  }
}
