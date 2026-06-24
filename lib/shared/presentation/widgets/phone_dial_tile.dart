import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:science_cup_app/shared/extensions/phone_number_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneDialTile extends StatelessWidget {
  final String? rawPhone;
  final PhoneNumber? phoneNumber;

  const PhoneDialTile({super.key, this.rawPhone, this.phoneNumber})
    : assert(rawPhone != null || phoneNumber != null);

  @override
  Widget build(BuildContext context) {
    final parsed = phoneNumber ?? rawPhone.tryParsePhoneNumber;

    final display = parsed == null
        ? (rawPhone ?? '?')
        : '+${parsed.countryCode} ${parsed.formatNsn()}';

    return InkWell(
      onTap: parsed == null
          ? null
          : () async {
              final uri = Uri(scheme: 'tel', path: parsed.international);

              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
      child: Row(
        spacing: 4,
        children: [
          Text(display),
          if (parsed != null) const Icon(Icons.open_in_new, size: 12),
        ],
      ),
    );
  }
}
