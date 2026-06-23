import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

// Tilføjer en global kontakt, som kan tilføjes til et hold.
class AddContactModal extends ConsumerWidget {
  const AddContactModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: 'Opret kontakt',
      fields: [
        TextFieldConfig(
          key: 'name',
          label: 'Navn',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
        ),
        PhoneFieldConfig(key: 'phone', label: 'Telefonnummer'),
      ],
      onSubmit: (data) async {
        // data['name'], data['email'], data['phone'] er trimmed Strings
        final name = data['name'] as String;
        final phone = data['phone'] as PhoneNumber;

        await ref
            .read(contactsProvider.notifier)
            .createContact(name: name, phone: phone.international);
      },
    );
  }
}
