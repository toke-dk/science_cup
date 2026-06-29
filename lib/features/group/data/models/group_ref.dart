import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_ref.freezed.dart';
part 'group_ref.g.dart';

@freezed
abstract class GroupRef with _$GroupRef {
  factory GroupRef({required int id, String? name}) = _GroupRef;

  factory GroupRef.fromJson(Map<String, dynamic> json) =>
      _$GroupRefFromJson(json);
}
