import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/application/game_notifier.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';

class GamesView extends ConsumerWidget {
  const GamesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSeasonId = ref.watch(currentSeasonProvider)?.id;
    if (currentSeasonId == null) {
      return const Center(child: Text("Ingen aktiv sæson valgt"));
    }

    final gamesState = ref.watch(gameProvider(currentSeasonId));

    return gamesState.when(
      data: (List<GameSummary> games) {
        print("Games: $games");
        if (games.isEmpty) {
          return const Center(child: Text("Ingen kampe fundet"));
        }
        return Column(
          children: games.map((game) {
            print("Game: $game");
            return Row(
              children: List.generate(2, (index) {
                final team = index == 0 ? game.homeTeam : game.awayTeam;
                if (team == null) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: [Text("${team.name ?? "Ukendt holdnavn"} ")],
                );
              }),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text("Fejl: $error")),
    );
  }
}
