import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/presentation/save_program_modal.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';

import '../../../shared/presentation/modals/create_entity_modal.dart';

class AddTeamModal extends ConsumerStatefulWidget {
  const AddTeamModal({super.key});

  @override
  ConsumerState<AddTeamModal> createState() => _AddTeamModalState();
}

class _AddTeamModalState extends ConsumerState<AddTeamModal> {
  List<Contact> _selectedContacts = [];

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
            selectedItems: _selectedContacts,
            itemAsString: (item) => item.name ?? "?",
            items: (filter, s) => contacts
                .where(
                  (e) =>
                      e.name?.toLowerCase().contains(filter.toLowerCase()) ??
                      false,
                )
                .toList(),
            compareFn: (item, selectedItem) => item.id == selectedItem.id,
            onSelected: (items) => print("selected: $items"),
            popupProps: MultiSelectionPopupProps.modalBottomSheet(
              emptyBuilder: (context, searchEntry) => Container(
                height: 70,
                alignment: Alignment.center,
                child: Text("Ingen kontakter fundet"),
              ),
              showSelectedItems: true,
              validationBuilder: (context, selectedItems) => Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedContacts = selectedItems;
                    });
                  },
                  child: Text("GEM"),
                ),
              ),

              containerBuilder: (ctx, popupWidget) {
                return Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ), // Padding hele vejen rundt
                  child: popupWidget,
                );
              },
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

        debugPrint(data["program"].runtimeType.toString());

        //ref.read(teamProvider(seasonId).notifier).createTeam(name: "Nyt Hold");
      },
    );
  }
}
