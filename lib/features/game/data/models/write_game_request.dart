import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/game/data/models/game.dart';

part 'write_game_request.freezed.dart';
part 'write_game_request.g.dart';

@freezed
abstract class WriteGameRequest with _$WriteGameRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory WriteGameRequest({
    int? id,

    // Relations
    required int seasonId,
    int? groupId,
    int? homeTeamId,
    int? awayTeamId,
    int? refereeTeamId,

    // Knockout
    int? roundNumber,
    int? matchNumber,
    int? nextGameId,
    GameSlot? nextGameSlot,
    int? winnerTeamId,

    // Status
    GameStatus? status,

    // Result
    int? homeScore,
    int? awayScore,

    // Clock
    int? clockBaseMinutes,
    DateTime? clockStartedAt,

    // Other
    bool? refereeAbsent,
    String? comment,

    // Schedule
    DateTime? startDate,
  }) = _WriteGameRequest;

  factory WriteGameRequest.fromJson(Map<String, dynamic> json) =>
      _$WriteGameRequestFromJson(json);
}
