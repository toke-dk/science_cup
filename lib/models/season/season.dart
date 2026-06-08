import 'package:freezed_annotation/freezed_annotation.dart';

part 'season.freezed.dart';
part 'season.g.dart';

@freezed
abstract class Season with _$Season {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Season({
    required int id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) = _Season;

  factory Season.fromJson(Map<String, dynamic> json) =>
      _$SeasonFromJson(json);
}