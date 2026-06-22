// features/auth/data/auth_repository.dart (eller application)
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/providers/supabase_provider.dart';
import 'package:science_cup_app/features/auth/data/auth_repository.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  // Returnér din konkrete implementation (evt. med Supabase-klient)
  return AuthRepository(supabase: supabase);
}
