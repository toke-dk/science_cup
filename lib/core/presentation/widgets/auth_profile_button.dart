import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:science_cup_app/features/auth/application/auth_notifier.dart';

class AuthProfileButton extends ConsumerWidget {
  const AuthProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authProvider).profile;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () async {
          if (profile == null) {
            context.push('/login');
            return;
          }
          await ref.read(authProvider.notifier).signOut();
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
