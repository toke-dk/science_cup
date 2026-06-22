import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/storage/shared_preferences_provider.dart';

import '../../data/repositories/active_season_id_repository.dart';

part 'active_season_id_repository_provider.g.dart';

@riverpod
ActiveSeasonIdRepository activeSeasonIdRepository(ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return ActiveSeasonIdRepository(prefs);
}
