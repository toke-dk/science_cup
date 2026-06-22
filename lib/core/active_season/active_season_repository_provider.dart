import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/storage/shared_preferences_provider.dart';

import 'active_season_repository.dart';

part 'active_season_repository_provider.g.dart';

@riverpod
ActiveSeasonRepository activeSeasonRepository(ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return ActiveSeasonRepository(prefs);
}
