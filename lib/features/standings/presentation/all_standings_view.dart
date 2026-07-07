// lib/features/standings/presentation/screens/all_standings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/standings/application/all_group_standings_provider.dart';
import 'package:science_cup_app/features/standings/data/group_standings.dart';
import 'package:science_cup_app/features/standings/data/standing_row.dart';

class AllStandingsView extends ConsumerWidget {
  const AllStandingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonId = ref.watch(currentSeasonProvider)?.id;
    if (seasonId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final allStandingsAsync = ref.watch(allGroupStandingsProvider(seasonId));

    return allStandingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fejl: $e')),
      data: (allStandings) => Column(
        children: [
          for (final groupStandings in allStandings)
            _GroupStandingsCard(groupStandings),
        ],
      ),
    );
  }
}

class _GroupStandingsCard extends StatelessWidget {
  final GroupStandings groupStandings;
  const _GroupStandingsCard(this.groupStandings);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gruppe-navn som header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Gruppe: ${groupStandings.group.name ?? 'Ukendt gruppe'}",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // Stillingstabel
          if (groupStandings.standings.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Ingen kampe spillet endnu'),
            )
          else
            _StandingsTable(groupStandings.standings),
        ],
      ),
    );
  }
}

class _StandingsTable extends StatelessWidget {
  final List<StandingRow> standings;
  const _StandingsTable(this.standings);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Hold')),
          DataColumn(label: Text('K')),
          DataColumn(label: Text('V')),
          DataColumn(label: Text('U')),
          DataColumn(label: Text('T')),
          DataColumn(label: Text('Mål')),
          DataColumn(label: Text('Diff')),
          DataColumn(label: Text('P')),
        ],
        rows: standings.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text(row.teamName)),
              DataCell(Text('${row.played}')),
              DataCell(Text('${row.wins}')),
              DataCell(Text('${row.draws}')),
              DataCell(Text('${row.losses}')),
              DataCell(Text('${row.goalsFor}-${row.goalsAgainst}')),
              DataCell(Text('${row.goalDifference}')),
              DataCell(Text('${row.points}')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
