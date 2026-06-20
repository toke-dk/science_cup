import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_insert_request.freezed.dart';
part 'contact_insert_request.g.dart';


@freezed
abstract class ContactCreateRequest with _$ContactCreateRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ContactCreateRequest({
    int? profileId,
    String? name,
    String? phone,
  }) = _ContactInsertRequest;

  factory ContactCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactCreateRequestFromJson(json);
}