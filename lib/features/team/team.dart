import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/contact/data/contact.dart';
import 'package:science_cup_app/features/program/data/program.dart';
import 'package:science_cup_app/features/season/data/season.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
abstract class Team with _$Team {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Team({
    int? id,
    String? name,
    DateTime? createdAt,
    Season? season,
    Program? program,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
