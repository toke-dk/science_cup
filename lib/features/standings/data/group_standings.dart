import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/standings/data/standing_row.dart';

class GroupStandings {
  final Group group;
  final List<StandingRow> standings;

  const GroupStandings({required this.group, required this.standings});
}
