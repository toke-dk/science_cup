// lib/features/season/application/active_season_persister.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/active_season/active_season_id_notifier.dart';
import 'package:science_cup_app/features/season/application/effective_active_season/effective_active_season_provider.dart';

part 'active_season_persister.g.dart';

@Riverpod(keepAlive: true)
void activeSeasonPersister(Ref ref) {
  final effectiveSeason = ref.watch(effectiveActiveSeasonProvider);
  if (effectiveSeason != null) {
    // Skriv til repository (og dermed SharedPreferences)
    ref.read(activeSeasonIdProvider.notifier).setSeasonId(effectiveSeason.id);
  }
}
