import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/group/application/group_repository_provider.dart';
import 'package:science_cup_app/features/group/application/group_with_teams_notifier.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';

part 'group_notifier.g.dart';

@Riverpod(keepAlive: true)
class GroupNotifier extends _$GroupNotifier {
  @override
  Future<List<Group>> build(int seasonId) async {
    // 2. Hent grupper for denne sæson
    final repository = ref.read(groupRepositoryProvider);
    return repository.getGroupsForSeason(seasonId);
  }

  // --- CREATE ---
  Future<void> saveGroup({int? id, required String name}) async {
    print("Mounted: ${ref.mounted}, ");

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
    print("Mounted: ${ref.mounted}, ");

    if (!ref.mounted) {
      print("Not mountd anymore");

      return;
    }

    // Genindlæs listen automatisk
    ref.invalidate(groupBoardStateProvider(seasonId));
    ref.invalidateSelf();
  }

  // --- DELETE ---
  Future<void> deleteGroup(String id) async {
    final repository = ref.read(groupRepositoryProvider);
    await repository.deleteGroup(id);
    ref.invalidateSelf();
    ref.invalidate(groupBoardStateProvider(seasonId));
  }
}
