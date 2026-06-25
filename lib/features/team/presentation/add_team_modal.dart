import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/contact/presentation/add_contact_modal.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/presentation/save_program_modal.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

import '../../../shared/presentation/modals/create_entity_modal.dart';

class AddTeamModal extends ConsumerStatefulWidget {
  const AddTeamModal({super.key, this.team});
  final Team? team;

  @override
  ConsumerState<AddTeamModal> createState() => _AddTeamModalState();
}

class _AddTeamModalState extends ConsumerState<AddTeamModal> {
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
      title: '${widget.team == null ? 'Opret' : 'Rediger'} Hold',
      fields: [
        SelectFieldConfig(
          key: "program",
          label: "Studie",
          options: programs,
          initialValue: widget.team?.program,
          optionLabel: (program) => program.name ?? "?",
          validator: (v) => v == null ? 'Vælg studie' : null,
          createEntity: () => showCreateEntityModalBottomSheet(
            context: context,
            builder: (context) => SaveProgramModal(),
          ),
        ),
        TextFieldConfig(key: "name", label: "Holdnavn"),
        DividerFieldConfig(height: 32, thickness: 1),
        TextConfig(label: 'Kontakter'),
        MultiSelectFieldConfig<Contact>(
          key: 'contacts',
          label: 'Kontakter',
          items: (filter) => contacts
              .where(
                (c) =>
                    c.name?.toLowerCase().contains(filter.toLowerCase()) ??
                    false,
              )
              .toList(),
          itemAsString: (item) => item.name ?? '?',
          itemLabelString: (item) => item.name ?? '?',
          itemSubtitleString: (item) => item.phone ?? '',
          initialValues: widget.team?.contacts,
          createEntity: () => showCreateEntityModalBottomSheet(
            context: context,
            builder: (context) => AddContactModal(),
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

        // ref.read(teamProvider(seasonId).notifier).saveTeam(name: "Nyt Hold");
      },
    );
  }
}
