import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../business_logic/auth_notifier.dart';

class PhoneLoginForm extends StatefulWidget {
  const PhoneLoginForm({super.key});

  @override
  State<PhoneLoginForm> createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends State<PhoneLoginForm> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !authNotifier.codeSent
          ? _buildPhoneInput(context) // TRIN 1: Indtast telefonnummer
          : _buildCodeInput(context), // TRIN 2: Indtast SMS-kode
    );
  }

  // Layout til at indtaste telefonnummer
  Widget _buildPhoneInput(BuildContext context) {
    return Column(
      key: const ValueKey('phoneInput'),
      children: [
        const Text('Indtast dit telefonnummer for at modtage en engangskode.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Telefonnummer',
            prefixText: '+45 ', // Fast landekode som eksempel
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final fullNumber = '+45${_phoneController.text.trim()}';
            await context.read<AuthNotifier>().startPhoneAuth(fullNumber);
          },
          child: const Text('Send SMS Kode'),
        ),
      ],
    );
  }

  // Layout til at indtaste den 6-cifrede SMS-kode
  Widget _buildCodeInput(BuildContext context) {
    return Column(
      key: const ValueKey('codeInput'),
      children: [
        const Text('Indtast den 6-cifrede kode, vi har sendt til dig.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: '6-cifret kode',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final success = await context.read<AuthNotifier>().verifyCode(_codeController.text.trim());
            if (success && context.mounted) {
              context.go('/seasons');
            }
          },
          child: const Text('Log ind'),
        ),
      ],
    );
  }
}