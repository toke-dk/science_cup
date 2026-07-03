import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/auth/application/auth_notifier.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';

class DisplayGame extends ConsumerWidget {
  const DisplayGame({super.key, required this.game});

  final GameSummary game;

  Widget _buildTeamRow(String? teamName) {
    return Row(
      children: [
        Text(teamName ?? "?"),
        // const SizedBox(width: 8.0),
        // TeamIcon(teamName: teamName ?? "?"),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canReportResult = ref.watch(
      authProvider.select((state) => state.profile?.canReportScore ?? false),
    );
    return Row(
      children: [
        _buildTeamRow(game.homeTeam?.name),
        const SizedBox(width: 16.0),
        const Text("-"),
        const SizedBox(width: 16.0),
        _buildTeamRow(game.awayTeam?.name),
        Spacer(),
        if (canReportResult)
          IconButton(
            icon: const Icon(Icons.assignment_add),
            onPressed: () {
              // Handle edit action
            },
          ),
      ],
    );
  }
}
