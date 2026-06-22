import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:science_cup_app/features/season/presentation/add_season_button.dart';

import '../application/season/season_notifier.dart';

class SeasonsView extends ConsumerWidget {
  const SeasonsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seasonsProvider);

    return state.when(
      loading: () => CircularProgressIndicator(),
      error: (_, error) => Text('Der skete en fejl: $error'),
      data: (seasons) {
        final sortedSeasons = List.of(seasons)
          ..sort(
            (a, b) => b.startDate?.compareTo(a.startDate ?? DateTime(0)) ?? 0,
          ); // Nyeste først
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: seasons.length,
              itemBuilder: (context, index) {
                final season = sortedSeasons[index];
                return ListTile(
                  onTap: () {
                    if (season.id == null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Ingen ID'),
                          content: Text(
                            'Denne sæson har ingen ID og kan ikke åbnes.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    context.go('/seasons/${season.id}');
                  },
                  title: Text(season.name ?? "Ingen navn"),
                  subtitle: Text('Start: ${season.startDate?.toLocal()} - Sl'),
                );
              },
            ),
            AddSeasonButton(),
          ],
        );
      },
    );
  }
}
