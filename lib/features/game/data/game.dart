import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

import '../../season/data/models/season.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
abstract class Game with _$Game {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Game({
    int? id,
    Season? season,
    Team? homeTeam,
    Team? awayTeam,
    int? homeScore,
    int? awayScore,
    Group? group,
    bool? refereeAbsent,
    String? comment,
    DateTime? createdAt,
    DateTime? startDate,
    Team? refereeTeam,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
