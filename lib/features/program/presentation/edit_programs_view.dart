import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/program/presentation/add_program_modal.dart';
import 'package:science_cup_app/features/program/state/program_notifier.dart';
import 'package:science_cup_app/providers/data_state.dart';

class ProgramsView extends StatelessWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context) {
    final programsState = context.watch<ProgramNotifier>().state;

    return programsState.when(
      initial: () => CircularProgressIndicator(),
      loading: () => CircularProgressIndicator(),
      loaded: (programs) {
        return Column(
          children: [
            Row(
              children: [
                Text("(#Studier)"),
                Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return AddProgramModal();
                      },
                    );
                  },
                  label: Text("Nyt Studie"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: programs.map((p) => Text(p.name ?? "?")).toList(),
            ),
          ],
        );
      },
      error: (e) => Text("Fejl ved indlæsning af programmer: $e"),
    );
  }
}
