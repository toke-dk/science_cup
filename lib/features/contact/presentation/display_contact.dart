import 'package:flutter/material.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/contact/presentation/extensions/contact_phone_ui_extension.dart';

class DisplayContact extends StatelessWidget {
  const DisplayContact({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelIconText(icon: Icons.person, label: contact.name ?? "Intet navn"),

        _LabelIconText(
          icon: Icons.phone,
          child: contact.displayPhoneWithCopyButton(context),
        ),
      ],
    );
  }
}

class _LabelIconText extends StatelessWidget {
  const _LabelIconText({required this.icon, this.label, this.child});

  final IconData icon;
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          label == null ? const SizedBox.shrink() : Text(label!),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
