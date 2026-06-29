import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/game/data/enums/game_enums.dart';

part 'report_game_request.freezed.dart';
part 'report_game_request.g.dart';

/// For reporting the result of a game, including the score, status, and any comments.
@freezed
abstract class ReportGameRequest with _$ReportGameRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ReportGameRequest({
    required int id,

    // Status
    GameStatus? status,

    // Result
    int? homeScore,
    int? awayScore,

    // Clock
    // int? clockBaseMinutes,
    // DateTime? clockStartedAt,

    // Other
    bool? refereeAbsent,
    String? comment,
  }) = _ReportGameRequest;

  factory ReportGameRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportGameRequestFromJson(json);
}
