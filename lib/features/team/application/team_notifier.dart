import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/features/team/data/repository/team_repository.dart';
import 'package:science_cup_app/features/team/providers/team_repository_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'team_notifier.g.dart';

@riverpod
class TeamNotifier extends _$TeamNotifier {
  @override
  FutureOr<List<Team>> build(int? activeSeasonId) async {
    // Hvis ingen sæson, returnér tom liste
    if (activeSeasonId == null) return const [];

    // Hent repository via provider - det er det mest korrekte
    final repository = ref.watch(teamRepositoryProvider);
    return repository.getTeamsForSeason(activeSeasonId);
  }

  TeamRepository get _repository =>
      TeamRepository(supabase: Supabase.instance.client);

  Future<void> createTeam({required String name}) async {
    // Da activeSeasonId allerede er kendt i build(), kan vi bruge det
    if (activeSeasonId == null) {
      state = AsyncError('Ingen aktiv sæson valgt', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    // Brug AsyncValue.guard til at håndtere try-catch automatisk
    state = await AsyncValue.guard(() async {
      final repository = ref.read(teamRepositoryProvider);
      await repository.createTeam(Team(name: name, seasonId: activeSeasonId!));

      // Når vi invaliderer, kaldes build() igen, og UI opdateres automatisk
      ref.invalidateSelf();

      // Vi returnerer den nye liste (eller lader build gøre arbejdet)
      return future;
    });
  }

  Future<void> updateTeam({required Team updatedTeam}) async {
    try {
      await _repository.updateTeam(updatedTeam);

      ref.invalidateSelf();
    } catch (e, stackTrace) {
      state = AsyncError('Kunne ikke opdatere hold: $e', stackTrace);
    }
  }

  Future<void> deleteTeam(String id) async {
    try {
      await _repository.deleteTeam(id);

      ref.invalidateSelf();
    } catch (e, stackTrace) {
      state = AsyncError('Kunne ikke slette hold: $e', stackTrace);
    }
  }
}
