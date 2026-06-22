import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/program/state/program_notifier.dart';
import 'package:science_cup_app/providers/data_state.dart';

import '../../shared/presentation/create_entity_modal.dart';

class AddTeamModal extends StatelessWidget {
  const AddTeamModal({super.key});

  @override
  Widget build(BuildContext context) {
    final programState = context.read<ProgramNotifier>().state;

    return programState.when(
      initial: () => CircularProgressIndicator(),
      loading: () => CircularProgressIndicator(),
      error: (e) => Text("Fejl ved indlæsning af programmer: $e"),
      loaded: (programs) {
        return CreateEntityModal(
          title: 'Opret gruppe',
          fields: [
            FieldConfig.select(
              key: "program",
              label: "Studie",
              options: programs,
              optionLabel: (program) => program.name ?? "?",
              validator: (v) => v == null ? 'Vælg studie' : null,
            ),
          ],
          onSubmit: (data) async {
            // data['name'] er en trimmed String
            // await context.read<TeamNotifier>().createTeam(name: data['name']);
          },
        );
      },
    );
  }
}
