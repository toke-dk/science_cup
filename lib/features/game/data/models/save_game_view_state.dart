import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

/// A class representing the data for saving a game, containing lists of groups and teams.
class SaveGameData {
  final List<Group> groups;
  final List<Team> teams;

  const SaveGameData({required this.groups, required this.teams});
}
