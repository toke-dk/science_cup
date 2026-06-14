import 'package:flutter/material.dart';
import 'package:science_cup_app/features/program/presentation/add_program_modal.dart';

class ProgramsView extends StatelessWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("(#Studier)"),
            Spacer(),
            FilledButton.icon(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context){
                  return AddProgramModal();
                });
              },
              label: Text("Ny Gruppe"),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        Text("Studier"),
      ],
    );
  }
}
