import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/create_entity_modal.dart';
import '../application/group_notifier.dart';

class AddGroupModal extends ConsumerWidget {
  const AddGroupModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: 'Opret gruppe',
      fields: [
        TextFieldConfig(
          key: 'name',
          label: 'Gruppenavn',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
        ),
      ],
      onSubmit: (data) async {
        // data['name'] er en trimmed String
        await ref.read(groupProvider.notifier).createGroup(name: data['name']);
      },
    );
  }
}
