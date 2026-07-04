// features/permissions/application/user_permissions_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/auth/application/auth_notifier.dart';
import 'package:science_cup_app/features/auth/data/profile_role.dart';
import 'package:science_cup_app/features/contact/application/contact_repository_provider.dart';
import 'package:science_cup_app/features/permissions/data/user_permission.dart';

// ... andre imports

part 'user_permissions_notifier.g.dart';

@Riverpod(keepAlive: true)
Future<UserPermissions> userPermissions(Ref ref) async {
  final authState = ref.watch(authProvider);

  if (authState.isLoading) {
    return const UserPermissions();
  }

  final profile = authState.profile;

  if (profile == null || profile.id == null) {
    return const UserPermissions();
  }

  if (profile.role == ProfileRole.admin) {
    return const UserPermissions(isAdmin: true);
  }

  final contactRepository = ref.read(contactRepositoryProvider);

  final teamIds = await contactRepository.getAccessibleTeamIds(profile.id!);

  return UserPermissions(accessibleTeamIds: teamIds.toSet());
}
