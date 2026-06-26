import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/auth/application/auth_notifier.dart';

class EmailLoginForm extends ConsumerStatefulWidget {
  const EmailLoginForm({super.key});

  @override
  ConsumerState<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends ConsumerState<EmailLoginForm> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final errorMessage = authState.errorMessage;
    final emailCodeSent = authState.emailCodeSent;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Viser fejlbesked hvis der er en
            if (errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),

            // Trin 1: Email-felt og send-knap
            if (!emailCodeSent) ...[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Indtast din e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'Ugyldig e-mail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(authProvider.notifier)
                                .sendEmailOtp(_emailController.text.trim());
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send kode'),
                ),
              ),
            ],

            // Trin 2: Kode-felt og verificer-knap
            if (emailCodeSent) ...[
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Engangskode',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Indtast koden fra din e-mail';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Annuller-knap
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Annuller'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Verificer-knap
                  Expanded(
                    child: FilledButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await ref
                                    .read(authProvider.notifier)
                                    .verifyEmailOtp(
                                      email: _emailController.text.trim(),
                                      token: _codeController.text.trim(),
                                    );
                                if (success && context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Log ind'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
