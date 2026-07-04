import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/data/models/game_summary.dart';
import 'package:science_cup_app/features/permissions/application/user_permissions_notifier.dart';

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
    final userPermissions = ref.watch(userPermissionsProvider).value;
    return userPermissions == null
        ? Text("Permissions er null")
        : Row(
            children: [
              _buildTeamRow(game.homeTeam?.name),
              const SizedBox(width: 16.0),
              const Text("-"),
              const SizedBox(width: 16.0),
              _buildTeamRow(game.awayTeam?.name),
              Spacer(),
              if (game.homeTeam?.id != null &&
                  userPermissions.canReportResults(game.homeTeam!.id))
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
