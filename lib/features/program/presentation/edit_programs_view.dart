import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/presentation/display_program.dart';
import 'package:science_cup_app/features/program/presentation/save_program_modal.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

class ProgramsView extends ConsumerWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsState = ref.watch(programProvider);

    return programsState.when(
      loading: () => Center(child: CircularProgressIndicator()),
      data: (programs) {
        return Column(
          children: [
            Row(
              children: [
                Text("(#Studier)"),
                Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    showCreateEntityModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SaveProgramModal();
                      },
                    );
                  },
                  label: Text("Nyt Studie"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Column(
              children: programs
                  .map(
                    (p) => DisplayProgram(
                      program: p,
                      onEdit: () {
                        showCreateEntityModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SaveProgramModal(initialProgram: p);
                          },
                        );
                      },
                      onDelete: (confirmed) {
                        if (!confirmed) return;
                        if (p.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Programmet har ikke et ID, og kan derfor ikke slettes. Kontakt support.",
                              ),
                            ),
                          );
                          return;
                        }

                        ref.read(programProvider.notifier).deleteProgram(p.id!);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
      error: (error, stacktrace) =>
          Text("Fejl ved indlæsning af programmer: $error"),
    );
  }
}
