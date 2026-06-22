// lib/features/season/application/active_season_persister.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/season/application/active_season/local_season_id_notifier.dart';

part 'active_season_persister.g.dart';

@Riverpod(keepAlive: true)
void activeSeasonPersister(Ref ref) {
  final effectiveSeason = ref.watch(currentSeasonProvider);
  if (effectiveSeason != null) {
    // Skriv til repository (og dermed SharedPreferences)
    ref.read(localSeasonIdProvider.notifier).setSeasonId(effectiveSeason.id);
  }
}
