import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/group/application/group_with_teams_notifier.dart';
import 'package:science_cup_app/features/team/application/team_repository_provider.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/features/team/data/models/write_team_request.dart';
import 'package:science_cup_app/features/team/data/repository/team_repository.dart';
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

  Future<void> saveTeam({
    int? id,
    String? name,
    int? programId,
    List<int>? contactIds,
  }) async {
    if (activeSeasonId == null) {
      state = AsyncError('Sæson er ikke valgt', StackTrace.current);
      return;
    }
    final request = WriteTeamRequest(
      seasonId: activeSeasonId!,
      id: id,
      name: name,
      programId: programId,
    );
    Team? result;
    try {
      if (id == null) {
        result = await _repository.createTeam(request);
      } else {
        result = await _repository.updateTeam(request);
      }
      if (result.id != null) {
        // Hvis vi har et resultat, opdater state
        state = AsyncData([...state.value ?? [], result]);
      }

      await createContactsForTeam(result.id!, contactIds ?? []);

      ref.invalidate(groupBoardStateProvider(activeSeasonId!));
      ref.invalidateSelf();
    } catch (e, stackTrace) {
      state = AsyncError('Kunne ikke opdatere hold: $e', stackTrace);
    }
  }

  Future<void> createContactsForTeam(int teamId, List<int> contactIds) async {
    for (final contactId in contactIds) {
      try {
        await _repository.addContactToTeam(
          teamId: teamId,
          contactId: contactId,
        );
      } catch (e, stackTrace) {
        state = AsyncError(
          'Kunne ikke tilføje kontakt til hold: $e',
          stackTrace,
        );
      }
    }
  }

  Future<void> deleteTeam(int id) async {
    try {
      await _repository.deleteTeam(id);

      ref.invalidate(groupBoardStateProvider(activeSeasonId!));
      ref.invalidateSelf();
    } catch (e, stackTrace) {
      state = AsyncError('Kunne ikke slette hold: $e', stackTrace);
    }
  }
}
