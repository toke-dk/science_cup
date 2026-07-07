import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';
import 'package:science_cup_app/features/game/presentation/add_game_score_modal.dart';
import 'package:science_cup_app/features/permissions/application/user_permissions_notifier.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

class DisplayGame extends ConsumerWidget {
  const DisplayGame({super.key, required this.game});

  final GameSummary game;

  Widget _buildTeamRow(String? teamName, {int? score}) {
    return Row(
      children: [
        Text(teamName ?? "?"),
        //const SizedBox(width: 8.0),
        //TeamIcon(teamName: teamName ?? "?"),
        const SizedBox(width: 8.0),
        score == null ? const SizedBox.shrink() : Text(score.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPermissions = ref.watch(userPermissionsProvider).value;
    return Row(
      children: [
        _buildTeamRow(game.homeTeam?.name, score: game.homeScore),
        const SizedBox(width: 16.0),
        const Text("-"),
        const SizedBox(width: 16.0),
        _buildTeamRow(game.awayTeam?.name, score: game.awayScore),
        Spacer(),
        if (game.homeTeam?.id != null &&
            userPermissions?.canReportResults(game.homeTeam!.id) == true)
          IconButton(
            icon: const Icon(Icons.assignment_add),
            onPressed: () {
              showCreateEntityModalBottomSheet(
                context: context,
                builder: (context) => AddGameResultModal(game: game),
              );
            },
          ),
      ],
    );
  }
}
