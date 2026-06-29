import 'package:flutter/material.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';

class DisplayGame extends StatelessWidget {
  const DisplayGame({super.key, required this.game});

  final GameSummary game;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        game.group != null
            ? Text("Gr. ${game.group!.name ?? "?"}")
            : const SizedBox.shrink(),
        Row(
          children: List.generate(2, (index) {
            final team = index == 0 ? game.homeTeam : game.awayTeam;
            if (team == null) {
              return const SizedBox.shrink();
            }
            return Row(children: [Text("${team.name ?? "Ukendt holdnavn"} ")]);
          }),
        ),
      ],
    );
  }
}
