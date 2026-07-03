import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/auth/data/profile_role.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const Profile._(); // Private constructor for Freezed

  @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
  const factory Profile({
    String? id,
    String? email,
    String? phone,
    ProfileRole? role,
    String? name,
    DateTime? createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  bool get canReportScore => role == ProfileRole.admin;
}
