import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/season/application/season/season_notifier.dart';
import 'package:science_cup_app/features/season/data/models/season.dart';
import 'package:science_cup_app/features/team/application/team_notifier.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

import '../../../shared/presentation/modals/create_entity_modal.dart';
import '../application/group_notifier.dart';

class AddGroupModal extends ConsumerStatefulWidget {
  const AddGroupModal({super.key, this.group});
  final Group? group;

  @override
  ConsumerState<AddGroupModal> createState() => _AddGroupModalState();
}

class _AddGroupModalState extends ConsumerState<AddGroupModal> {
  Season? _selectedSeason;

  @override
  void initState() {
    super.initState();
    // Startværdi = den aktuelle sæson (læses synkront)
    _selectedSeason = ref.read(currentSeasonProvider);
  }

  @override
  Widget build(BuildContext context) {
    final seasonsAsync = ref.watch(seasonsProvider);
    final teamsAsync = _selectedSeason != null
        ? ref.watch(teamProvider(_selectedSeason!.id))
        : const AsyncValue.data(<Team>[]);

    return seasonsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fejl: $e')),
      data: (seasons) {
        // Hvis startværdi var null, sæt til første sæson
        if (_selectedSeason == null && seasons.isNotEmpty) {
          _selectedSeason = seasons.first;
        }

        return CreateEntityModal(
          // 🔑 Ny key hver gang teams eller sæson skifter → modal nulstilles
          key: ValueKey(_selectedSeason?.id),
          title: '${widget.group == null ? "Opret" : "Rediger"} gruppe',
          fields: [
            SelectFieldConfig<Season>(
              key: 'season',
              label: 'Sæson',
              options: seasons,
              optionLabel: (s) => s.name ?? '?',
              initialValue: _selectedSeason,
              onFieldSelected: (season) {
                setState(() => _selectedSeason = season);
              },
            ),
            DividerFieldConfig(),
            TextFieldConfig(
              key: 'name',
              label: 'Gruppenavn',
              validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
            ),
            MultiSelectFieldConfig<Team>(
              key: 'teams',
              label: 'Hold',
              items: (filter) => teamsAsync.value ?? <Team>[],
              itemAsString: (t) => t.name ?? '?',
              disabledBuilder: (t) => t.group != null,
            ),
          ],
          onSubmit: (data) async {
            final name = data['name'] as String;
            final season = data['season'] as Season;
            final teams = data['teams'] as List<Team>;
            return;
            // TODO:
            await ref.read(groupProvider.notifier).createGroup(name: name);
          },
        );
      },
    );
  }
}
