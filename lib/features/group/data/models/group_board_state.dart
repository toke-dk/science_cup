import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/group/data/models/group_with_teams.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

part 'group_board_state.freezed.dart';
part 'group_board_state.g.dart';

@freezed
abstract class GroupBoardState with _$GroupBoardState {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory GroupBoardState({
    required List<GroupWithTeams> groupsWithTeams,
    required List<Team> unassignedTeams,
  }) = _GroupBoardState;

  factory GroupBoardState.fromJson(Map<String, dynamic> json) =>
      _$GroupBoardStateFromJson(json);
}
