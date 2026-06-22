import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/presentation/add_program_modal.dart';

class ProgramsView extends ConsumerWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsState = ref.watch(programProvider);

    return programsState.when(
      loading: () => CircularProgressIndicator(),
      data: (programs) {
        return Column(
          children: [
            Row(
              children: [
                Text("(#Studier)"),
                Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
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
      error: (error, stacktrace) =>
          Text("Fejl ved indlæsning af programmer: $error"),
    );
  }
}
