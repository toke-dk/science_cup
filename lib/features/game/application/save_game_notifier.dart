import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/game/application/game_repository_provider.dart';
import 'package:science_cup_app/features/game/data/enums/game_enums.dart';
import 'package:science_cup_app/features/game/data/models/save_game_view_state.dart';
import 'package:science_cup_app/features/game/data/models/write_game_request.dart';
import 'package:science_cup_app/features/group/application/group_repository_provider.dart';
import 'package:science_cup_app/features/team/application/team_repository_provider.dart';

part 'save_game_notifier.g.dart';

@riverpod
class SaveGameNotifier extends _$SaveGameNotifier {
  @override
  Future<SaveGameData> build(int seasonId) async {
    final groupRepo = ref.read(groupRepositoryProvider);
    final teamRepo = ref.read(teamRepositoryProvider);

    final groups = await groupRepo.getGroupsForSeason(seasonId);
    final teams = await teamRepo.getTeamsForSeason(seasonId);

    return SaveGameData(groups: groups, teams: teams);
  }

  Future<void> saveGame({
    int? id,
    required int seasonId,
    int? groupId,
    int? homeTeamId,
    int? awayTeamId,
    int? refereeTeamId,
    int? roundNumber,
    int? matchNumber,
    int? nextGameId,
    GameSlot? nextGameSlot,
    int? winnerTeamId,
    GameStatus? status,
    int? homeScore,
    int? awayScore,
    bool? refereeAbsent,
    String? comment,
    DateTime? startDate,
  }) async {
    final request = WriteGameRequest(
      seasonId: seasonId,
      groupId: groupId,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      id: id,
      refereeTeamId: refereeTeamId,
      roundNumber: roundNumber,
      matchNumber: matchNumber,
      nextGameId: nextGameId,
      nextGameSlot: nextGameSlot,
      winnerTeamId: winnerTeamId,
      status: status,
      homeScore: homeScore,
      awayScore: awayScore,
      refereeAbsent: refereeAbsent,
      comment: comment,
      startDate: startDate,
    );
    final gameRepo = ref.read(gameRepositoryProvider);

    if (request.id == null) {
      await gameRepo.createGame(request);
    } else {
      await gameRepo.updateGame(request);
    }
  }
}
