import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';
import 'package:science_cup_app/features/team/presentation/add_team_modal.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';
import 'package:science_cup_app/shared/presentation/widgets/confirmation_dialog/confirmation_fields.dart';
import 'package:science_cup_app/shared/presentation/widgets/edit_delete_menu.dart';

class EditTeamsView extends ConsumerWidget {
  const EditTeamsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonId = ref.watch(currentSeasonProvider)?.id;
    final teamsState = ref.watch(teamProvider(seasonId));

    if (seasonId == null) {
      return const Center(child: Text("Vælg en sæson for at se hold"));
    }

    return teamsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text("Fejl ved indlæsning af hold: $error")),
      data: (groups) => Column(
        children: [
          Row(
            children: [
              Text("${groups.length} hold"),
              Spacer(),
              FilledButton.icon(
                onPressed: () {
                  showCreateEntityModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddTeamModal();
                    },
                  );
                },
                label: Text("Nyt Hold"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Column(
            children: groups
                .map(
                  (indexProgram) => ListTile(
                    title: Text(indexProgram.name ?? "Ingen navn"),
                    subtitle: Text(
                      indexProgram.program?.name ?? "Ingen program",
                    ),
                    trailing: EditDeleteMenu(
                      onEdit: () {
                        showCreateEntityModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return AddTeamModal(team: indexProgram);
                          },
                        );
                      },
                      confirmationFields: ConfirmationFields(
                        title: "Sletning af hold",
                        content: "Du er ved at slette et hold",
                        confirmButtonText: "Slet",
                      ),
                      onDelete: (confirmed) async {
                        if (!confirmed) return;
                        if (indexProgram.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Holdet har ikke et ID")),
                          );
                          return;
                        }

                        ref
                            .read(teamProvider(seasonId).notifier)
                            .deleteTeam(indexProgram.id!);
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
