import 'package:freezed_annotation/freezed_annotation.dart';

part 'program.freezed.dart';

part 'program.g.dart';

/// A program is a "studieretning" and are responsible for multiple teams. A team can only be in one program, but a program can have multiple teams.
@freezed
abstract class Program with _$Program {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Program({
    int? id,
    String? name,
    String? nickname,
    DateTime? createdAt,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}
