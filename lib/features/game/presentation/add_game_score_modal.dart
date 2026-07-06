import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/application/report_game_results_notifier.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

class AddGameScoreModal extends ConsumerWidget {
  const AddGameScoreModal({super.key, required this.game});

  final GameSummary game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: 'Indberet resultat',
      fields: [
        TextFieldConfig(
          label: "Score: ${game.homeTeam?.name ?? "Hjemmehold"}",
          key: 'home_score',
          onlyNumbers: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Indtast score for hjemmehold';
            }
            return null;
          },
        ),
        TextFieldConfig(
          label: "Score: ${game.awayTeam?.name ?? "Udehold"}",
          key: 'away_score',
          onlyNumbers: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Indtast score for udehold';
            }
            return null;
          },
        ),
      ],
      onSubmit: (data) async {
        final homeScore = int.tryParse(data['home_score'] ?? '');
        final awayScore = int.tryParse(data['away_score'] ?? '');
        final seasonId = ref.read(currentSeasonProvider)?.id;

        if (seasonId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ingen aktiv sæson valgt')),
          );
          return;
        }

        if (homeScore == null || awayScore == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ugyldig score indtastet')),
          );
          return;
        }

        ref.read(
          reportGameResultProvider(
            gameId: game.id,
            homeScore: homeScore,
            awayScore: awayScore,
          ),
        );
      },
    );
  }
}
