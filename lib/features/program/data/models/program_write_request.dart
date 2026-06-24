import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_write_request.freezed.dart';
part 'program_write_request.g.dart';

@freezed
abstract class ProgramWriteRequest with _$ProgramWriteRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ProgramWriteRequest({
    required String name,
    String? nickname,
    int? id,
  }) = _ProgramWriteRequest;

  factory ProgramWriteRequest.fromJson(Map<String, dynamic> json) =>
      _$ProgramWriteRequestFromJson(json);
}
