import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/group/application/group_repository_provider.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';

part 'group_notifier.g.dart';

@riverpod
class GroupNotifier extends _$GroupNotifier {
  @override
  Future<List<Group>> build(int? seasonId) async {
    if (seasonId == null) return [];

    // 2. Hent grupper for denne sæson
    final repository = ref.read(groupRepositoryProvider);
    return repository.getGroupsForSeason(seasonId);
  }

  // --- CREATE ---
  Future<void> saveGroup({int? id, required String name}) async {
    final seasonId = ref.read(currentSeasonProvider)?.id;
    if (seasonId == null) {
      throw Exception('Ingen aktiv sæson valgt');
    }

    final repository = ref.read(groupRepositoryProvider);
    final newGroup = Group(name: name, seasonId: seasonId, id: id);

    if (id != null) {
      // Hvis id er givet, opdater eksisterende gruppe
      await repository.updateGroup(newGroup);
    } else {
      // Ellers opret ny gruppe
      await repository.createGroup(newGroup);
    }

    if (!ref.mounted) return;

    // Genindlæs listen automatisk
    ref.invalidateSelf();
  }

  // --- DELETE ---
  Future<void> deleteGroup(String id) async {
    final repository = ref.read(groupRepositoryProvider);
    await repository.deleteGroup(id);
    ref.invalidateSelf();
  }
}
