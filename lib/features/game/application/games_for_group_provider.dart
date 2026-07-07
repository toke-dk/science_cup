import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/game/application/game_repository_provider.dart';
import 'package:science_cup_app/features/game/data/models/game.dart';

part 'games_for_group_provider.g.dart';

@riverpod
Future<List<Game>> gamesForGroup(Ref ref, int groupId) {
  // Antager at dit repository har en metode getGamesForGroup
  // Hvis ikke, kan du hente alle kampe for sæsonen og filtrere
  return ref.watch(gameRepositoryProvider).getGamesForGroup(groupId);
}
