import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/core/providers/data_state.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/season/application/season_notifier.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';

import '../../shared/presentation/create_entity_modal.dart';

class AddTeamModal extends ConsumerWidget {
  const AddTeamModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            final seasonId = context.read<SeasonsNotifier>().currentSeasonId;
            if (seasonId == null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Ingen sæson valgt")));
              return;
            }
            ref
                .read(teamProvider(seasonId).notifier)
                .createTeam(name: "Nyt Hold");
          },
        );
      },
    );
  }
}
