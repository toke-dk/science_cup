import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/modals/create_entity_modal.dart';
import '../application/program_notifier.dart';

class AddProgramModal extends ConsumerWidget {
  const AddProgramModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: 'Opret studie',
      fields: [
        TextFieldConfig(
          key: 'name',
          label: 'Navn på studie',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
        ),
        TextFieldConfig(key: "nickName", label: "Kaldenavn (valgfri)"),
      ],
      onSubmit: (data) async {
        final name = data['name'] as String;
        final nickname = data['nickName'] as String?;

        await ref
            .read(programProvider.notifier)
            .createProgram(name: name, nickname: nickname);
      },
    );
  }
}
