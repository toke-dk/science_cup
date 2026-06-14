import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/group_notifier.dart';
import '../../shared/presentation/create_entity_modal.dart';

class AddGroupModal extends StatelessWidget {
  const AddGroupModal({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateEntityModal(
      title: 'Opret gruppe',
      fields: [
        FieldConfig.text(
          key: 'name',
          label: 'Gruppenavn',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
        ),
      ],
      onSubmit: (data) async {
        // data['name'] er en trimmed String
        await context.read<GroupNotifier>().createGroup(name: data['name']);
      },
    );
  }
}
