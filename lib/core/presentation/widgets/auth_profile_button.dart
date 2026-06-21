import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/auth/state/auth_notifier.dart';

class AuthProfileButton extends StatelessWidget {
  const AuthProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthNotifier>().profile;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () async {
          if (profile == null) {
            context.push('/login');
            return;
          }
          await context.read<AuthNotifier>().signOut();
        },
        child: CircleAvatar(
          radius: 32,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: profile == null
                  ? const Icon(Icons.person)
                  : Text(
                      profile.email?[0] ?? "?",
                      style: const TextStyle(fontSize: 40),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
