import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/data/repositories/season_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'season_repository_provider.g.dart';

@riverpod
SeasonRepository seasonRepository(ref) {
  final supabase = Supabase.instance.client;

  return SeasonRepository(supabase: supabase);
}
