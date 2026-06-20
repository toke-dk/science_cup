import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_create_request.freezed.dart';
part 'contact_create_request.g.dart';

@freezed
abstract class ContactCreateRequest with _$ContactCreateRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ContactCreateRequest({
    int? profileId,
    required String name,
    String? phone,
  }) = _ContactCreateRequest;

  factory ContactCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactCreateRequestFromJson(json);
}
