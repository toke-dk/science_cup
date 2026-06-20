import 'package:flutter/material.dart';

import '../../shared/presentation/create_entity_modal.dart';

class AddTeamModal extends StatelessWidget {
  const AddTeamModal({super.key});

  @override
  Widget build(BuildContext context) {


    return CreateEntityModal(
      title: 'Opret gruppe',
      fields: [
        FieldConfig.select(key: "program", label: "Studie", options: <String>["Et studie her"], optionLabel: (program) => program, validator: (v) => v == null ? 'Vælg studie' : null),
      ],
      onSubmit: (data) async {
        // data['name'] er en trimmed String
        // await context.read<TeamNotifier>().createTeam(name: data['name']);
      },
    );
  }
}
