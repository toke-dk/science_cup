import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/team/application/team_repository_provider.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

part 'team_providers.g.dart';

// Provider for alle hold i en sæson (bruges evt. af teamsByGroupProvider)
@riverpod
Future<List<Team>> seasonTeams(Ref ref, int seasonId) {
  return ref.watch(teamRepositoryProvider).getTeamsForSeason(seasonId);
}

// Provider der filtrerer holdene baseret på gruppeId
@riverpod
Future<List<Team>> teamsByGroup(Ref ref, int groupId) async {
  // Hvis du kender seasonId, kan du hente alle hold i sæsonen og filtrere
  // Men du kan også have en dedikeret repository-metode: getTeamsByGroup(groupId)
  // Her viser jeg den fleksible måde med seasonId fra en anden provider:
  final seasonId = ref.watch(currentSeasonProvider)?.id;
  if (seasonId == null) return [];

  final allTeams = await ref.watch(seasonTeamsProvider(seasonId).future);
  return allTeams.where((t) => t.group?.id == groupId).toList();
}
