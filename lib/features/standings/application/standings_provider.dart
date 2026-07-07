import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/game/application/games_for_group_provider.dart';
import 'package:science_cup_app/features/standings/data/standing_row.dart';
import 'package:science_cup_app/features/standings/data/standings_calculator.dart';
import 'package:science_cup_app/features/team/application/team_providers.dart';

part 'standings_provider.g.dart';

@riverpod
Future<List<StandingRow>> standings(Ref ref, int groupId) async {
  final games = await ref.watch(gamesForGroupProvider(groupId).future);
  final teams = await ref.watch(teamsByGroupProvider(groupId).future);

  // Filtrér ugyldige hold fra og log en advarsel
  final teamInfos = <TeamInfo>[];
  for (final team in teams) {
    if (team.id != null && team.name != null) {
      teamInfos.add(TeamInfo(id: team.id!, name: team.name!));
    } else {
      // Brug en logger i produktion – her bruger vi debugPrint
      print('ADVARSEL: Team med null id eller name ignoreret – team: $team');
    }
  }

  return calculateStandings(games, teamInfos);
}
