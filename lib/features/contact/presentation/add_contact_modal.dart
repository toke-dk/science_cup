import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/shared/extensions/phone_number_extension.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

// Tilføjer en global kontakt, som kan tilføjes til et hold.
class AddContactModal extends ConsumerWidget {
  const AddContactModal({super.key, this.contact});

  final Contact? contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: 'Opret kontakt',
      fields: [
        TextFieldConfig(
          key: 'name',
          label: 'Navn',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
          initialValue: contact?.name,
        ),
        PhoneFieldConfig(
          key: 'phone',
          label: 'Telefonnummer',
          initialValue: contact?.phone.tryParsePhoneNumber,
        ),
      ],
      onSubmit: (data) async {
        // data['name'], data['email'], data['phone'] er trimmed Strings
        final name = data['name'] as String;
        final phone = data['phone'] as PhoneNumber;

        await ref
            .read(contactsProvider.notifier)
            .saveContact(
              contactId: contact?.id,
              name: name,
              phone: phone.international,
            );
      },
    );
  }
}
