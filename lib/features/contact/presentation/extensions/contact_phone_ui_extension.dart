import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:science_cup_app/features/contact/data/extensions/contact_phone_extension.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';

extension ContactPhoneUiExtension on Contact {
  Widget displayPhoneWithCopyButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: phone!));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Telefonnummer kopieret til udklipsholder')),
        );
      },
      child: Row(
        spacing: 4,
        children: [
          Text(formattedPhoneNumber),
          phone == null ? SizedBox.shrink() : Icon(Icons.copy, size: 12),
        ],
      ),
    );
  }
}
