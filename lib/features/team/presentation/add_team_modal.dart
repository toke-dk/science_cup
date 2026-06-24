import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/presentation/add_contact_modal.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/presentation/save_program_modal.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';

import '../../../shared/presentation/modals/create_entity_modal.dart';

class AddTeamModal extends ConsumerStatefulWidget {
  const AddTeamModal({super.key});

  @override
  ConsumerState<AddTeamModal> createState() => _AddTeamModalState();
}

class _AddTeamModalState extends ConsumerState<AddTeamModal> {
  int amountOfContactsToAdd = 0;

  @override
  Widget build(BuildContext context) {
    final programState = ref.watch(programProvider);
    final contactsState = ref.watch(contactsProvider);

    // Tjek om begge er klar
    final isLoading = programState.isLoading || contactsState.isLoading;
    final hasError = programState.hasError || contactsState.hasError;

    if (isLoading) {
      return Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Center(child: CircularProgressIndicator())],
        ),
      );
    }

    if (hasError) {
      final error = programState.error ?? contactsState.error;
      return Text('Fejl ved indlæsning: $error');
    }

    // Begge er klar data er garanteret!
    final programs = programState.value!;
    final contacts = contactsState.value!;
    return CreateEntityModal(
      title: 'Opret Hold',
      fields: [
        SelectFieldConfig(
          key: "program",
          label: "Studie",
          options: programs,
          optionLabel: (program) => program.name ?? "?",
          validator: (v) => v == null ? 'Vælg studie' : null,
        ),
        OpenBottomSheetFieldConfig(
          builder: (context) => SaveProgramModal(),
          icon: Icon(Icons.add),
          label: "Nyt studie",
        ),
        DividerFieldConfig(height: 32, thickness: 1),
        TextConfig(label: 'Kontakter'),
        ...List.generate(
          amountOfContactsToAdd,
          (index) => [
            SelectFieldConfig(
              key: "contacts",
              label: "Vælg kontakt",
              options: contacts,
              optionLabel: (contact) => contact.name ?? "?",
            ),
            OpenBottomSheetFieldConfig(
              builder: (context) => AddContactModal(),
              icon: Icon(Icons.add),
              label: "Ny kontakt",
            ),
          ],
        ).expand((e) => e),
        WidgetFieldConfig(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                amountOfContactsToAdd++;
                debugPrint('Amount of contacts to add: $amountOfContactsToAdd');
              });
            },
            icon: Icon(Icons.add),
            label: Text("Tilføj kontakt"),
          ),
        ),
      ],
      onSubmit: (data) async {
        final seasonId = ref.read(currentSeasonProvider)?.id;
        if (seasonId == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Ingen sæson valgt")));
          return;
        }
        ref.read(teamProvider(seasonId).notifier).createTeam(name: "Nyt Hold");
      },
    );
  }
}
