import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/active_season/active_season_id_repository_provider.dart';
import 'package:science_cup_app/features/season/data/repositories/active_season_id_repository.dart';

part 'active_season_id_notifier.g.dart';

@riverpod
class ActiveSeasonIdNotifier extends _$ActiveSeasonIdNotifier {
  late final ActiveSeasonIdRepository _repo = ref.read(
    activeSeasonIdRepositoryProvider,
  );

  @override
  Future<int?> build() async {
    return _repo.load();
  }

  Future<void> setSeasonId(int? seasonId) async {
    state = AsyncData(seasonId);
    await _repo.setSeasonId(seasonId);
  }

  Future<void> clear() async {
    state = const AsyncData(null);
    await _repo.setSeasonId(null);
  }
}
