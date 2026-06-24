import 'package:flutter/material.dart';
import 'package:science_cup_app/shared/presentation/widgets/confirmation_dialog/confirmation_fields.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.confirmationFields});

  final ConfirmationFields confirmationFields;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(confirmationFields.title),
      content: Text(confirmationFields.content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Annuller"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmationFields.confirmButtonText),
        ),
      ],
    );
  }
}
