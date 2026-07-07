import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/game/application/game_repository_provider.dart';
import 'package:science_cup_app/features/game/data/models/game.dart';

part 'game_provider.g.dart';

@riverpod
Future<Game> game(Ref ref, int gameId) {
  return ref.watch(gameRepositoryProvider).getGame(gameId);
}
