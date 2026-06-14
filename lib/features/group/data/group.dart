import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/season/data/season.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
abstract class Group with _$Group {
  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Group({
    int? id,
    String? name,
    String? nickname,
    int? seasonId,
    DateTime? createdAt,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
