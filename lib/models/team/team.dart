import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/models/contact/contact.dart';
import 'package:science_cup_app/models/program/program.dart';
import 'package:science_cup_app/models/season/season.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
abstract class Team with _$Team {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Team({
    required int id,
    String? name,
    DateTime? createdAt,
    Season? season,
    Contact? primaryContact,
    Contact? secondaryContact,
    Program? program,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) =>
      _$TeamFromJson(json);
}