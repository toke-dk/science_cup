import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/game/application/game_notifier.dart';
import 'package:science_cup_app/features/game/application/game_repository_provider.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';

part 'report_game_results_notifier.g.dart';

@riverpod
Future<void> reportGameResult(
  Ref ref, {
  required int gameId,
  required int homeScore,
  required int awayScore,
}) async {
  await ref
      .read(gameRepositoryProvider)
      .reportGameResult(
        gameId: gameId,
        homeScore: homeScore,
        awayScore: awayScore,
      );
  ref.invalidate(gameProvider(ref.read(currentSeasonProvider)?.id ?? 0));
}
