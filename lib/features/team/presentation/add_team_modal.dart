import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/season/application/active_season/active_season_id_notifier.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';

import '../../shared/presentation/create_entity_modal.dart';

class AddTeamModal extends ConsumerWidget {
  const AddTeamModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programState = ref.read(programProvider);

    return programState.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stacktrace) =>
          Text("Fejl ved indlæsning af programmer: $error"),
      data: (programs) {
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
            final seasonId = ref.read(activeSeasonIdProvider).value;
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
