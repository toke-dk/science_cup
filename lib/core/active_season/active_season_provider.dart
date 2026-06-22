import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/active_season/active_season_repository.dart';
import 'package:science_cup_app/core/active_season/active_season_repository_provider.dart';
import 'package:science_cup_app/features/season/data/season.dart';

part 'active_season_provider.g.dart';

@riverpod
class ActiveSeason extends _$ActiveSeason {
  late final ActiveSeasonRepository _repo = ref.read(
    activeSeasonRepositoryProvider,
  );

  @override
  Future<Season?> build() async {
    return _repo.load();
  }

  Future<void> selectSeason(Season season) async {
    state = AsyncData(season);
    await _repo.save(season);
  }

  Future<void> clear() async {
    state = const AsyncData(null);
    await _repo.save(null);
  }
}
