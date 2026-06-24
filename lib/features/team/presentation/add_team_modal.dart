import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
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
        WidgetFieldConfig(
          child: DropdownSearch<Contact>.multiSelection(
            items: (filter, s) => contacts
                .where((e) => e.name?.contains(filter) ?? false)
                .toList(),
            compareFn: (item, selectedItem) => item.id == selectedItem.id,
            popupProps: MultiSelectionPopupProps.modalBottomSheet(
              containerBuilder: (ctx, popupWidget) {
                return Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ), // Padding hele vejen rundt
                  child: popupWidget,
                );
              },
              applyButtonProps: ButtonProps(
                text: 'Tilføj',
                icon: Icon(Icons.add),
              ),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  labelText: 'Søg kontakter',
                  border: OutlineInputBorder(),
                ),
              ),

              showSearchBox: true,
              itemBuilder: (context, item, isDisabled, isSelected) {
                return ListTile(
                  title: Text(item.name ?? "?"),
                  subtitle: Text(item.phone ?? "?"),
                );
              },
              suggestionsProps: SuggestionsProps(
                showSuggestions: true,
                items: (us) {
                  return us
                      .where((e) => e.name?.contains("Mrs") ?? false)
                      .toList();
                },
                itemProps: SuggestedItemProps(),
              ),
            ),
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
