import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_write_request.freezed.dart';
part 'contact_write_request.g.dart';

@freezed
abstract class ContactWriteRequest with _$ContactWriteRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ContactWriteRequest({
    int? profileId,
    required String name,
    String? phone,
  }) = _ContactWriteRequest;

  factory ContactWriteRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactWriteRequestFromJson(json);
}
