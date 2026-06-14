
import 'package:flutter/cupertino.dart';
import 'package:science_cup_app/features/group/data/group.dart';
import 'package:science_cup_app/features/group/data/group_repository.dart';
import 'package:science_cup_app/features/season/data/season.dart';

import '../../../providers/data_state.dart';

class GroupNotifier extends ChangeNotifier {
  final GroupRepository _repository;
  int? _activeSeasonId;

  DataState<List<Group>> _state = const DataState.initial();
  DataState<List<Group>> get state => _state;

  GroupNotifier(this._repository);

  void updateActiveSeason(int? seasonId) {
    if (_activeSeasonId != seasonId) {
      _activeSeasonId = seasonId;
      if (seasonId != null) {
        loadGroupsForActiveSeason();
      }
    }
  }

  // READ
  Future<void> loadGroupsForActiveSeason() async {
    if (_activeSeasonId == null) return;

    _state = const DataState.loading();
    notifyListeners();

    try {
      final groups = await _repository.getGroupsForSeason(_activeSeasonId!);
      _state = DataState.loaded(groups);
    } catch (e) {
      _state = DataState.error(e.toString());
    }
    print("groups loaded for season $_activeSeasonId: groups");
    notifyListeners();
  }


  // CREATE
  Future<void> createGroup({
    required String name,
    required int seasonId,
  }) async {
    try {
      final newDraft = Group(name: name, seasonId: seasonId);

      await _repository.createGroup(newDraft);

      await loadGroupsForActiveSeason();
    } catch (e) {
      _state = DataState.error('Kunne ikke oprette gruppe: $e');
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateGroup({required Group updatedSeason}) async {
    try {
      await _repository.updateGroup(updatedSeason);

      await loadGroupsForActiveSeason();
    } catch (e) {
      _state = DataState.error('Kunne ikke opdatere gruppe: $e');
      notifyListeners();
    }
  }

  // 4. DELETE
  Future<void> deleteGroup(String id) async {
    try {
      await _repository.deleteGroup(id);

      await loadGroupsForActiveSeason();
    } catch (e) {
      _state = DataState.error('Kunne ikke slette sæson: $e');
      notifyListeners();
    }
  }
}
