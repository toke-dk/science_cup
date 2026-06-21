import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/team/presentation/add_team_modal.dart';
import 'package:science_cup_app/features/team/state/team_notifier.dart';
import 'package:science_cup_app/providers/data_state.dart';

class EditTeamsView extends StatelessWidget {
  const EditTeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final teamsState = context.watch<TeamNotifier>().state;

    return teamsState.when(
      initial: () => const Center(child: Text("Vælg en sæson for at se hlold")),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) =>
          Center(child: Text("Fejl ved indlæsning af hold: $message")),
      loaded: (groups) => Column(
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
