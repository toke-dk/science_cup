// lib/features/season/application/route_season_id_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/navigation/app_router.dart';

part 'route_season_id_provider.g.dart';

@riverpod
int? routeSeasonId(Ref ref) {
  final router = ref.watch(appRouterProvider);
  final currentConfig =
      router.routerDelegate.currentConfiguration; // RouteMatchList
  final uri = currentConfig.uri; // Uri
  final segments = uri.pathSegments; // List<String>

  // Forventet mønster: /seasons/:id/...
  // F.eks. ['seasons', '1', 'games']
  if (segments.length >= 2 && segments[0] == 'seasons') {
    return int.tryParse(segments[1]);
  }
  return null;
}
