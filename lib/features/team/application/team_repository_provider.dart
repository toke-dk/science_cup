import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/core/providers/supabase_provider.dart';
import 'package:science_cup_app/features/team/data/repository/team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  // Vi lytter på supabase klienten
  final supabase = ref.watch(supabaseClientProvider);

  // Vi returnerer repository'et
  return TeamRepository(supabase: supabase);
});
