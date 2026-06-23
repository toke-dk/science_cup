import 'package:flutter/material.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

// Tilføjer en global kontakt, som kan tilføjes til et hold.
class AddContactModal extends StatelessWidget {
  const AddContactModal({super.key});

  @override
  Widget build(BuildContext context) {
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
        debugPrint("Opretter kontakt med data: ${data["phone"].runtimeType}");
      },
    );
  }
}
