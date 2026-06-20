import 'package:flutter/cupertino.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/features/team/data/repository/team_repository.dart';

import '../../../providers/data_state.dart';

class TeamNotifier extends ChangeNotifier {
  final TeamRepository _repository;
  int? _activeSeasonId;

  DataState<List<Team>> _state = const DataState.initial();
  DataState<List<Team>> get state => _state;

  TeamNotifier(this._repository);

  void updateActiveSeason(int? seasonId) {
    if (_activeSeasonId != seasonId) {
      _activeSeasonId = seasonId;
      if (seasonId != null) {
        loadTeamsForActiveSeason();
      }
    }
  }

  // READ
  Future<void> loadTeamsForActiveSeason() async {
    if (_activeSeasonId == null) return;

    _state = const DataState.loading();
    notifyListeners();

    try {
      final teams = await _repository.getTeamsForSeason(_activeSeasonId!);
      _state = DataState.loaded(teams);
    } catch (e) {
      _state = DataState.error(e.toString());
    }
    print("teams loaded for season $_activeSeasonId: teams");
    notifyListeners();
  }

  // CREATE
  Future<void> createTeam({required String name, int? seasonId}) async {
    if (seasonId == null && _activeSeasonId == null) {
      _state = const DataState.error('Ingen aktiv sæson valgt');
      notifyListeners();
      return;
    }
    try {
      final newDraft = Team(name: name, seasonId: seasonId ?? _activeSeasonId);

      await _repository.createTeam(newDraft);

      await loadTeamsForActiveSeason();
    } catch (e) {
      _state = DataState.error('Kunne ikke oprette hold: $e');
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateTeam({required Team updatedTeam}) async {
    try {
      await _repository.updateTeam(updatedTeam);

      await loadTeamsForActiveSeason();
    } catch (e) {
      _state = DataState.error('Kunne ikke opdatere hold: $e');
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteTeam(String id) async {
    try {
      await _repository.deleteTeam(id);

      await loadTeamsForActiveSeason();
    } catch (e) {
      _state = DataState.error('Kunne ikke slette hold: $e');
      notifyListeners();
    }
  }
}
