// presentation/modals/add_game_score_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/application/game_result_notifier.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

class AddGameResultModal extends ConsumerWidget {
  const AddGameResultModal({super.key, required this.game});
  final GameSummary game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gameResultProvider(game.id).notifier);
    final state = ref.watch(gameResultProvider(game.id));

    if (state.isInitialLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
    return CreateEntityModal(
      title: 'Indberet resultat',
      fields: [
        state.errorMessage == null
            ? EmptyFieldConfig()
            : TextConfig(label: state.errorMessage!),
        TextFieldConfig(
          label: "Score: ${game.homeTeam?.name ?? "Hjemmehold"}",
          key: 'home_score',
          onlyNumbers: true,
          initialValue: state.homeScore?.toString(),
          onChanged: (value) {
            final score = int.tryParse(value) ?? 0;
            notifier.setHomeScore(score);
          },
        ),
        TextFieldConfig(
          label: "Score: ${game.awayTeam?.name ?? "Udehold"}",
          key: 'away_score',
          onlyNumbers: true,
          initialValue: state.awayScore?.toString(),
          onChanged: (value) {
            final score = int.tryParse(value) ?? 0;
            notifier.setAwayScore(score);
          },
        ),
      ],
      onSubmit: (_) async {
        debugPrint(
          "Submitting game result for gameId: ${game.id}, homeScore: ${state.homeScore}, awayScore: ${state.awayScore}",
        );
        await notifier.submit();
        debugPrint("Finished submitting game result for gameId: ${game.id}");
      },
      isLoading: state.isSubmitting,
    );
  }
}
