import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/storage/shared_preferences_provider.dart';
import 'package:science_cup_app/features/season/data/repositories/local_season_id_repository.dart';

part 'local_season_id_repository_provider.g.dart';

@riverpod
LocalSeasonIdRepository localSeasonIdRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return LocalSeasonIdRepository(prefs);
}
