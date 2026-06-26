import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/program/data/models/program.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
abstract class Team with _$Team {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Team({
    int? id,
    String? name,
    DateTime? createdAt,
    int? seasonId,
    Program? program,
    List<Contact>? contacts,
    Group? group,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
