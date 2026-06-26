import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

part 'group_with_teams.freezed.dart';
part 'group_with_teams.g.dart';

@freezed
abstract class GroupWithTeams with _$GroupWithTeams {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory GroupWithTeams({
    required Group? group,
    required List<Team> teams,
  }) = _GroupWithTeams;

  factory GroupWithTeams.fromJson(Map<String, dynamic> json) =>
      _$GroupWithTeamsFromJson(json);
}
