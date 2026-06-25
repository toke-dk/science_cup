import 'package:freezed_annotation/freezed_annotation.dart';

part 'write_team_request.freezed.dart';
part 'write_team_request.g.dart';

@freezed
abstract class WriteTeamRequest with _$WriteTeamRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory WriteTeamRequest({
    required int seasonId,
    int? id,
    String? name,
    int? programId,
  }) = _WriteTeamRequest;

  factory WriteTeamRequest.fromJson(Map<String, dynamic> json) =>
      _$WriteTeamRequestFromJson(json);
}
