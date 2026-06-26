import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/providers/supabase_provider.dart';
import 'package:science_cup_app/features/group/data/repositories/group_repository.dart';

part 'group_repository_provider.g.dart';

@riverpod
GroupRepository groupRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GroupRepository(supabase: supabase);
}
