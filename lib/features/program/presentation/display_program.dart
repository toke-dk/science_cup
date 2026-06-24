import 'package:flutter/material.dart';
import 'package:science_cup_app/features/program/data/models/program.dart';
import 'package:science_cup_app/shared/presentation/widgets/confirmation_dialog/confirmation_fields.dart';
import 'package:science_cup_app/shared/presentation/widgets/edit_delete_menu.dart';

class DisplayProgram extends StatelessWidget {
  const DisplayProgram({
    super.key,
    required this.program,
    this.onEdit,
    this.onDelete,
  });

  final Program program;
  final Function()? onEdit;
  final Function(bool confirmed)? onDelete;

  @override
  Widget build(BuildContext context) {
    print("DisplayProgram: $onEdit, $onDelete");
    return ListTile(
      title: Text(program.name ?? "?"),
      subtitle: Text(program.nickname ?? "?"),
      trailing: EditDeleteMenu(
        onEdit: onEdit,
        onDelete: onDelete,
        confirmationFields: ConfirmationFields(
          title: "Slet program",
          content: "Er du sikker på, at du vil slette ${program.name ?? '?'}?",
          confirmButtonText: "Slet",
        ),
      ),
    );
  }
}
