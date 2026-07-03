import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/group/application/group_repository_provider.dart';
import 'package:science_cup_app/features/group/data/models/group_board_state.dart';

part 'group_with_teams_notifier.g.dart';

@riverpod
class GroupBoardStateNotifier extends _$GroupBoardStateNotifier {
  @override
  Future<GroupBoardState> build(int seasonId) async {
    print('Building GroupBoardStateNotifier for seasonId: $seasonId');
    // 2. Hent grupper for denne sæson
    final repository = ref.read(groupRepositoryProvider);

    return repository.getGroupBoard(seasonId);
  }

  Future<void> updateGroupTeams(int id, List<int> selectedTeamIds) async {
    final repository = ref.read(groupRepositoryProvider);
    await repository.updateGroupTeams(id, selectedTeamIds);
    ref.invalidateSelf();
  }
}
