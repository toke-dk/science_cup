import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/season/season_repository_provider.dart';
import 'package:science_cup_app/features/season/data/models/season.dart';

part 'season_notifier.g.dart';

@riverpod
class SeasonsNotifier extends _$SeasonsNotifier {
  @override
  Future<List<Season>> build() async {
    final repo = ref.read(seasonRepositoryProvider);
    return repo.getAllSeasons();
  }

  // CREATE
  Future<void> createSeason({
    required String name,
    DateTime? start,
    DateTime? end,
  }) async {
    final repo = ref.read(seasonRepositoryProvider);

    final newSeason = Season(name: name, startDate: start, endDate: end);

    await repo.createSeason(newSeason);

    ref.invalidateSelf(); // reload seasons
  }

  // UPDATE
  Future<void> updateSeason({required Season updatedSeason}) async {
    final repo = ref.read(seasonRepositoryProvider);

    await repo.updateSeason(updatedSeason);

    ref.invalidateSelf();
  }

  // DELETE
  Future<void> deleteSeason(String id) async {
    final repo = ref.read(seasonRepositoryProvider);

    await repo.deleteSeason(id);

    ref.invalidateSelf();
  }
}
