import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/providers/supabase_provider.dart';
import 'package:science_cup_app/features/game/data/repositories/game_repository.dart';

part 'game_repository_provider.g.dart';

@riverpod
GameRepository gameRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GameRepository(supabase: supabase);
}
