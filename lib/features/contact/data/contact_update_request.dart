import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_update_request.freezed.dart';
part 'contact_update_request.g.dart';

@freezed
abstract class ContactUpdateRequest with _$ContactUpdateRequest {
  // Vi bruger includeIfNull: false, så kun de ændrede felter sendes til Supabase
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory ContactUpdateRequest({
    String? name,
    String? phone,
    int? profileId,
  }) = _ContactUpdateRequest;

  factory ContactUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactUpdateRequestFromJson(json);
}