import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/auth/data/profile.dart';
import 'package:science_cup_app/features/group/data/group.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Contact({
    int? id,
    Profile? profile,
    Group? group,
    bool? isPrimary,
    DateTime? createdAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}