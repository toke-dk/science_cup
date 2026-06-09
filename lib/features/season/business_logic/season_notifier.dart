import 'package:flutter/material.dart';
import 'package:science_cup_app/features/season/data/season.dart';
import 'package:science_cup_app/features/season/data/season_repository.dart';

import '../../../providers/data_state.dart';

class SeasonsNotifier extends ChangeNotifier {
  final SeasonRepository _repository;

  DataState<List<Season>> _state = const DataState.initial();
  DataState<List<Season>> get state => _state;

  SeasonsNotifier(this._repository);

  // 1. READ
  Future<void> loadSeasons() async {
    _state = const DataState.loading();
    notifyListeners();

    try {
      final seasons = await _repository.getAllSeasons();
      _state = DataState.loaded(seasons);
    } catch (e) {
      _state = DataState.error(e.toString());
    }
    notifyListeners();
  }

  // 2. CREATE
  Future<void> addSeason({
    required String name,
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final newDraft = Season(name: name, startDate: start, endDate: end);

      // Vi beder repository om at gemme, men provideren styrer hvad der sker bagefter
      await _repository.createSeason(newDraft);

      await loadSeasons(); // Hent den friske liste, så UI opdateres automatisk
    } catch (e) {
      _state = DataState.error('Kunne ikke oprette sæson: $e');
      notifyListeners();
    }
  }

  // 3. UPDATE
  Future<void> updateSeason({required Season updatedSeason}) async {
    try {
      // 1. Bed dit repository om at opdatere rækken i Supabase via UUID
      await _repository.updateSeason(updatedSeason);

      // 2. Hent listen forfra så UI'et viser det nye navn eller datoer
      await loadSeasons();
    } catch (e) {
      _state = DataState.error('Kunne ikke opdatere sæson: $e');
      notifyListeners();
    }
  }

  // 4. DELETE
  Future<void> deleteSeason(String id) async {
    try {
      // 1. Bed repository om at slette rækken i Supabase via dens UUID
      await _repository.deleteSeason(id);

      // 2. Genindlæs listen, så den slettede sæson forsvinder fra skærmen med det samme
      await loadSeasons();
    } catch (e) {
      _state = DataState.error('Kunne ikke slette sæson: $e');
      notifyListeners();
    }
  }
}
