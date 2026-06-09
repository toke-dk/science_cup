import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Contact({
    int? id,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}