import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/game/data/enums/game_enums.dart';

part 'write_game_request.freezed.dart';
part 'write_game_request.g.dart';

// For creating or updating a game, including its relationships, schedule, and knockout information.
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
    int? nextGameId,
    GameSlot? nextGameSlot,
    int? winnerTeamId,

    // Schedule
    DateTime? startDate,
  }) = _WriteGameRequest;

  factory WriteGameRequest.fromJson(Map<String, dynamic> json) =>
      _$WriteGameRequestFromJson(json);
}
