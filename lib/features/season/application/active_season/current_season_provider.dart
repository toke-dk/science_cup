// lib/features/season/application/effective_active_season_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/season/application/active_season/local_season_id_notifier.dart';
import 'package:science_cup_app/features/season/application/active_season/route_season_id_provider.dart';
import 'package:science_cup_app/features/season/application/season/season_notifier.dart';
import 'package:science_cup_app/features/season/data/models/season.dart'; // seasonsProvider

part 'current_season_provider.g.dart';

@riverpod
Season? currentSeason(Ref ref) {
  final routeId = ref.watch(routeSeasonIdProvider); // int? fra URL
  final storedIdAsync = ref.watch(localSeasonIdProvider); // AsyncValue<int?>
  final seasonsAsync = ref.watch(seasonsProvider); // AsyncValue<List<Season>>

  final seasons = seasonsAsync.value;
  if (seasons == null || seasons.isEmpty) return null;

  // 1) Route har forrang
  if (routeId != null) {
    return _findById(seasons, routeId) ??
        _resolveFallback(storedIdAsync, seasons);
  }

  // 2) Ellers brug gemt ID
  return _resolveFallback(storedIdAsync, seasons);
}

Season? _findById(List<Season> seasons, int id) {
  try {
    return seasons.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}

Season _resolveFallback(AsyncValue<int?> storedAsync, List<Season> seasons) {
  final storedId = storedAsync.value;
  if (storedId != null) {
    final storedSeason = _findById(seasons, storedId);
    if (storedSeason != null) return storedSeason;
  }
  return seasons.first; // absolut fallback
}
