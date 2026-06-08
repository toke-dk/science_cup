import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/models/group/group.dart';
import 'package:science_cup_app/models/team/team.dart';

import '../season/season.dart';

part 'program.freezed.dart';
part 'program.g.dart';

/// A program is a "studieretning" and are responsible for multiple teams. A team can only be in one program, but a program can have multiple teams.
@freezed
abstract class Program with _$Program {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Program({
    int? id,
    String? name,
    DateTime? createdAt,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}