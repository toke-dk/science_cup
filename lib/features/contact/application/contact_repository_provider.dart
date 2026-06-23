import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/providers/supabase_provider.dart';
import 'package:science_cup_app/features/contact/data/repositories/contact_repository.dart';

part 'contact_repository_provider.g.dart';

@riverpod
ContactRepository contactRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ContactRepository(supabase: supabase);
}
