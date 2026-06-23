import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/presentation/add_program_modal.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';

import '../../../shared/presentation/create_entity_modal.dart';

class AddTeamModal extends ConsumerWidget {
  const AddTeamModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programState = ref.watch(programProvider);

    return programState.when(
      loading: () {
        debugPrint("Loading programs for add team modal");
        return CircularProgressIndicator();
      },
      error: (error, stacktrace) =>
          Text("Fejl ved indlæsning af programmer: $error"),
      data: (programs) {
        return CreateEntityModal(
          title: 'Opret gruppe',
          fields: [
            SelectFieldConfig(
              key: "program",
              label: "Studie",
              options: programs,
              optionLabel: (program) => program.name ?? "?",
              validator: (v) => v == null ? 'Vælg studie' : null,
            ),
            WidgetFieldConfig(
              child: FilledButton.tonalIcon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const AddProgramModal(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Nyt studie"),
              ),
            ),
          ],
          onSubmit: (data) async {
            final seasonId = ref.read(currentSeasonProvider)?.id;
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
