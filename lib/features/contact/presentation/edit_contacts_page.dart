import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/presentation/add_contact_modal.dart';
import 'package:science_cup_app/features/contact/presentation/display_contact.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

class EditContactsView extends ConsumerWidget {
  const EditContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);

    return contacts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text("Fejl ved indlæsning af kontakter: $error")),
      data: (contacts) => Column(
        children: [
          Row(
            children: [
              Text("${contacts.length} kontakter"),
              Spacer(),
              FilledButton.icon(
                onPressed: () {
                  showCreateEntityModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddContactModal();
                    },
                  );
                },
                label: Text("Ny Kontakt"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contacts
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: DisplayContact(
                      contact: c,
                      onEdit: () {
                        showCreateEntityModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return AddContactModal(contact: c);
                          },
                        );
                      },
                      onDelete: () async {
                        if (c.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Kan ikke slette kontakt uden ID. Kontakt support.",
                              ),
                            ),
                          );
                          return;
                        }

                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Slet kontakt"),
                            content: Text(
                              "Er du sikker på, at du vil slette kontakten '${c.name}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Annuller"),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Slet"),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await ref
                              .read(contactsProvider.notifier)
                              .deleteContact(c.id!);
                        }
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
