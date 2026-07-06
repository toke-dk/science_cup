import 'package:flutter/material.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

class AddGameScoreModal extends StatelessWidget {
  const AddGameScoreModal({super.key, required this.game});

  final GameSummary game;

  @override
  Widget build(BuildContext context) {
    return CreateEntityModal(
      title: 'Indberet resultat',
      fields: [
        TextFieldConfig(
          label: "Score: ${game.homeTeam?.name ?? "Hjemmehold"}",
          key: 'home_score',
          onlyNumbers: true,
        ),
        TextFieldConfig(
          label: "Score: ${game.awayTeam?.name ?? "Udehold"}",
          key: 'away_score',
          onlyNumbers: true,
        ),
      ],
      onSubmit: (data) async {},
    );
  }
}
