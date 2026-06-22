import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/season/application/season_notifier.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';
import 'package:science_cup_app/features/team/presentation/add_team_modal.dart';

class EditTeamsView extends ConsumerWidget {
  const EditTeamsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonId = context.watch<SeasonsNotifier>().currentSeasonId;
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
                  showModalBottomSheet(
                    isScrollControlled: true,
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
          ListView(
            shrinkWrap: true,
            children: groups
                .map((g) => ListTile(title: Text(g.name ?? "Ingen navn")))
                .toList(),
          ),
        ],
      ),
    );
  }
}
