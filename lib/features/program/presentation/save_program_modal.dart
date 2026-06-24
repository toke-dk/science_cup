import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/program/data/models/program.dart';

import '../../../shared/presentation/modals/create_entity_modal.dart';
import '../application/program_notifier.dart';

class SaveProgramModal extends ConsumerWidget {
  const SaveProgramModal({super.key, this.initialProgram});

  final Program? initialProgram;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: initialProgram != null ? 'Rediger studie' : 'Opret studie',
      fields: [
        TextFieldConfig(
          key: 'name',
          label: 'Navn på studie',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
          initialValue: initialProgram?.name,
        ),
        TextFieldConfig(
          key: "nickName",
          label: "Kaldenavn (valgfri)",
          initialValue: initialProgram?.nickname,
        ),
      ],
      onSubmit: (data) async {
        final name = data['name'] as String;
        final nickname = data['nickName'] as String?;

        await ref
            .read(programProvider.notifier)
            .saveProgram(
              name: name,
              nickname: nickname,
              id: initialProgram?.id,
            );
      },
    );
  }
}
