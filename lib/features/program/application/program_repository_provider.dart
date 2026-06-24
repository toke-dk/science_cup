import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/providers/supabase_provider.dart';
import 'package:science_cup_app/features/program/data/repositories/program_repository.dart';

part 'program_repository_provider.g.dart';

@riverpod
ProgramRepository programRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProgramRepository(supabase: supabase);
}
