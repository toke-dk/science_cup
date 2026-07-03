import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/group/presentation/add_group_modal.dart';
import 'package:science_cup_app/features/group/presentation/display_group_with_team.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

import '../application/group_with_teams_notifier.dart';

class EditGroupsView extends ConsumerWidget {
  const EditGroupsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonId = ref.watch(currentSeasonProvider)?.id;

    if (seasonId == null) {
      return const Center(child: Text("Ingen sæson valgt"));
    }
    final groupsState = ref.watch(groupBoardStateProvider(seasonId));

    return groupsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stacktrace) =>
          Center(child: Text("Fejl ved indlæsning af grupper: $error")),
      data: (groupBoardState) => Column(
        children: [
          Row(
            children: [
              Text("${groupBoardState.groupsWithTeams.length} grupper"),
              Spacer(),
              FilledButton.icon(
                onPressed: () {
                  showCreateEntityModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddGroupModal();
                    },
                  );
                },
                label: Text("Ny Gruppe"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Column(
            children: groupBoardState.groupsWithTeams
                .map(
                  (g) => DisplayGroupWithTeam(
                    groupWithTeam: g,
                    unassignedTeams: groupBoardState.unassignedTeams,
                    allowEditing: true,
                    onTeamsChanged: (selectedTeams) async {
                      print(
                        "Selected teams for group ${g.group?.name}: ${selectedTeams.map((t) => t.name).join(", ")}",
                      );
                      await ref
                          .read(groupBoardStateProvider(seasonId).notifier)
                          .updateGroupTeams(
                            g.group!.id!,
                            selectedTeams.map((t) => t.id!).toList(),
                          );
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
