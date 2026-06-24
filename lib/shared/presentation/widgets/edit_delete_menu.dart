import 'package:flutter/material.dart';
import 'package:science_cup_app/shared/presentation/widgets/confirmation_dialog/confirmation_dialog.dart';
import 'package:science_cup_app/shared/presentation/widgets/confirmation_dialog/confirmation_fields.dart';

class EditDeleteMenu extends StatelessWidget {
  const EditDeleteMenu({
    super.key,
    this.onEdit,
    this.onDelete,
    this.confirmationFields,
  });

  final Function()? onEdit;
  // To have a confirmation, provide confirmationFields. If not provided, the deletion is confirmed by default.
  final Function(bool confirmed)? onDelete;
  final ConfirmationFields? confirmationFields;

  List<PopupMenuItem<String>> _buildMenuItems() {
    final List<PopupMenuItem<String>> items = [];

    if (onEdit != null) {
      items.add(
        PopupMenuItem(
          value: 'edit',
          child: ListTile(leading: Icon(Icons.edit), title: Text("Rediger")),
        ),
      );
    }

    if (onDelete != null) {
      items.add(
        PopupMenuItem(
          value: 'delete',
          child: ListTile(leading: Icon(Icons.delete), title: Text("Slet")),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return onEdit == null && onDelete == null
        ? SizedBox.shrink()
        : PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'edit':
                  onEdit?.call();
                case 'delete':
                  bool confirmed = true;

                  // If no confirmation fields are provided, the deletion is confirmed by default.
                  if (confirmationFields != null) {
                    confirmed =
                        await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            confirmationFields: confirmationFields!,
                          ),
                        ) ??
                        false;
                  }
                  onDelete?.call(confirmed);
              }
            },
            itemBuilder: (context) => _buildMenuItems(),
          );
  }
}
