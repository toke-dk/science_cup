import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_ref.freezed.dart';
part 'team_ref.g.dart';

@freezed
abstract class TeamRef with _$TeamRef {
  factory TeamRef({required int id, String? name}) = _TeamRef;

  factory TeamRef.fromJson(Map<String, dynamic> json) =>
      _$TeamRefFromJson(json);
}
