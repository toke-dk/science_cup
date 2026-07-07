import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/group/application/group_notifier.dart';
import 'package:science_cup_app/features/standings/application/standings_provider.dart';
import 'package:science_cup_app/features/standings/data/group_standings.dart';

part 'all_group_standings_provider.g.dart';

@riverpod
Future<List<GroupStandings>> allGroupStandings(Ref ref, int seasonId) async {
  // 1. Hent alle grupper for sæsonen
  final groups = await ref.watch(groupProvider(seasonId).future);

  // 2. For hver gruppe: hent stillingen
  final standingsFutures = groups.map((group) async {
    final standings = await ref.watch(standingsProvider(group.id!).future);
    return GroupStandings(group: group, standings: standings);
  });

  // 3. Vent på alle stillinger er beregnet
  return Future.wait(standingsFutures);
}
