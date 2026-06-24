import 'package:flutter/material.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/shared/presentation/widgets/phone_dial_tile.dart';

class DisplayContact extends StatelessWidget {
  const DisplayContact({
    super.key,
    required this.contact,
    this.onEdit,
    this.onDelete,
  });

  final Contact contact;
  final Function()? onEdit;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LabelIconText(
                icon: Icons.person,
                label: contact.name ?? "Intet navn",
              ),

              _LabelIconText(
                icon: Icons.phone,
                child: PhoneDialTile(rawPhone: contact.phone),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit?.call();
              case 'delete':
                onDelete?.call();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text("Rediger"),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(leading: Icon(Icons.delete), title: Text("Slet")),
            ),
          ],
        ),
      ],
    );
  }
}

class _LabelIconText extends StatelessWidget {
  const _LabelIconText({required this.icon, this.label, this.child});

  final IconData icon;
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          label == null ? const SizedBox.shrink() : Text(label!),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
