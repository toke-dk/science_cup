import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:science_cup_app/features/auth/application/auth_notifier.dart';

class EmailLoginForm extends ConsumerStatefulWidget {
  const EmailLoginForm({super.key});

  @override
  ConsumerState<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends ConsumerState<EmailLoginForm> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_codeSent) ...[
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'E-mail'),
            keyboardType: TextInputType.emailAddress,
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(authProvider.notifier)
                  .sendEmailOtp(_emailController.text);
              setState(() => _codeSent = true);
            },
            child: const Text('Send kode'),
          ),
        ] else ...[
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: '6-cifret kode'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref
                  .read(authProvider.notifier)
                  .verifyEmailOtp(
                    email: _emailController.text,
                    token: _codeController.text,
                  );
              if (success && context.mounted) {
                context.pop();
              }
            },
            child: const Text('Log ind'),
          ),
        ],
      ],
    );
  }
}
