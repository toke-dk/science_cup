import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/core/providers/data_state.dart';
import 'package:science_cup_app/features/season/presentation/add_season_button.dart';

import '../state/season_notifier.dart';

class SeasonsView extends StatelessWidget {
  const SeasonsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SeasonsNotifier>().state;

    return state.when(
      initial: () => CircularProgressIndicator(),
      loading: () => CircularProgressIndicator(),
      error: (error) => Text('Der skete en fejl: $error'),
      loaded: (seasons) {
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
