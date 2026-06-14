import 'package:flutter/material.dart';

import '../../shared/presentation/create_entity_modal.dart';

class AddProgramModal extends StatelessWidget {
  const AddProgramModal({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateEntityModal(
      title: 'Opret sæson',
      fields: [
        FieldConfig.text(
          key: 'name',
          label: 'Navn på studie',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
        ),
        FieldConfig.text(key: "nickName", label: "Kaldenavn (valgfri)")
      ],
      onSubmit: (data) async {

      },
    );
  }
}
