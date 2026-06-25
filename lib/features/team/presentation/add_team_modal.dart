import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/contact/application/contacts_notifier.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/contact/presentation/add_contact_modal.dart';
import 'package:science_cup_app/features/program/application/program_notifier.dart';
import 'package:science_cup_app/features/program/data/models/program.dart';
import 'package:science_cup_app/features/program/presentation/save_program_modal.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/season/application/season/season_notifier.dart';
import 'package:science_cup_app/features/season/data/models/season.dart';
import 'package:science_cup_app/features/season/presentation/add_season_modal.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

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
    final seasonsState = ref.watch(seasonsProvider);
    final currentSeason = ref.watch(currentSeasonProvider);

    // Tjek om begge er klar
    final isLoading =
        programState.isLoading ||
        contactsState.isLoading ||
        seasonsState.isLoading;
    final hasError =
        programState.hasError ||
        contactsState.hasError ||
        seasonsState.hasError;

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
      final error =
          programState.error ?? contactsState.error ?? seasonsState.error;
      return Text('Fejl ved indlæsning: $error');
    }

    // Begge er klar data er garanteret!
    final programs = programState.value!;
    final contacts = contactsState.value!;
    final seasons = seasonsState.value!;
    return CreateEntityModal(
      title: '${widget.team == null ? 'Opret' : 'Rediger'} Hold',
      fields: [
        SelectFieldConfig(
          key: "season",
          label: "Sæson",
          options: seasons,
          initialValue: currentSeason,
          optionLabel: (season) => season.name ?? "?",
          validator: (v) => v == null ? 'Vælg Sæson' : null,
          createEntityWidget: AddSeasonModal(),
        ),
        DividerFieldConfig(height: 32, thickness: 1),
        SelectFieldConfig(
          key: "program",
          label: "Studie",
          options: programs,
          initialValue: widget.team?.program,
          optionLabel: (program) => program.name ?? "?",
          validator: (v) => v == null ? 'Vælg studie' : null,
          createEntityWidget: SaveProgramModal(),
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
          createEntityWidget: AddContactModal(),
        ),
      ],
      onSubmit: (data) async {
        final season = data["season"] as Season?;

        if (season?.id == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Ingen sæson valgt")));
          return;
        }

        final program = data["program"] as Program?;
        final name = data["name"] as String?;
        final contacts = (data["contacts"] as List<dynamic>?)
            ?.map((c) => c as Contact)
            .toList();

        ref
            .read(teamProvider(season!.id!).notifier)
            .saveTeam(
              id: widget.team?.id,
              name: name,
              programId: program?.id,
              contactIds: contacts?.map((c) => c.id!).toList(),
            );
      },
    );
  }
}
