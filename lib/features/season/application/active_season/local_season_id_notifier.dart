import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/active_season/local_season_id_repository_provider.dart';
import 'package:science_cup_app/features/season/data/repositories/local_season_id_repository.dart';

part 'local_season_id_notifier.g.dart';

@riverpod
class LocalSeasonIdNotifier extends _$LocalSeasonIdNotifier {
  late final LocalSeasonIdRepository _repo = ref.read(
    localSeasonIdRepositoryProvider,
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
