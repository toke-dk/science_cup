import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/group/application/group_repository_provider.dart';
import 'package:science_cup_app/features/group/data/group.dart';
import 'package:science_cup_app/features/season/application/effective_active_season/effective_active_season_provider.dart';

part 'group_notifier.g.dart';

@riverpod
class GroupNotifier extends _$GroupNotifier {
  @override
  Future<List<Group>> build() async {
    // 1. Reaktiv afhængighed af aktivt seasonId
    final seasonId = ref.watch(effectiveActiveSeasonProvider)?.id;
    if (seasonId == null) return [];

    // 2. Hent grupper for denne sæson
    final repository = ref.read(groupRepositoryProvider);
    return repository.getGroupsForSeason(seasonId);
  }

  // --- CREATE ---
  Future<void> createGroup({required String name}) async {
    final seasonId = ref.read(effectiveActiveSeasonProvider)?.id;
    if (seasonId == null) {
      throw Exception('Ingen aktiv sæson valgt');
    }

    final repository = ref.read(groupRepositoryProvider);
    final newGroup = Group(name: name, seasonId: seasonId);
    await repository.createGroup(newGroup);

    // Genindlæs listen automatisk
    ref.invalidateSelf();
  }

  // --- UPDATE ---
  Future<void> updateGroup({required Group updatedGroup}) async {
    final repository = ref.read(groupRepositoryProvider);
    await repository.updateGroup(updatedGroup);
    ref.invalidateSelf();
  }

  // --- DELETE ---
  Future<void> deleteGroup(String id) async {
    final repository = ref.read(groupRepositoryProvider);
    await repository.deleteGroup(id);
    ref.invalidateSelf();
  }
}
