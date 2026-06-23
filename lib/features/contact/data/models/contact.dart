import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Contact({
    int? id,
    int? profileId,
    String? name,
    String? phone,
    DateTime? createdAt,
    final List<Team>? teams,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
