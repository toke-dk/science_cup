import 'package:flutter/cupertino.dart';
import 'package:science_cup_app/features/program/data/program_repository.dart';

import '../../../core/providers/data_state.dart';
import '../data/program.dart';

class ProgramNotifier extends ChangeNotifier {
  final ProgramRepository _repository;

  DataState<List<Program>> _state = const DataState.initial();
  DataState<List<Program>> get state => _state;

  ProgramNotifier(this._repository);

  // READ
  Future<void> loadPrograms() async {
    _state = const DataState.loading();
    notifyListeners();

    try {
      final programs = await _repository.getPrograms();
      _state = DataState.loaded(programs);
    } catch (e) {
      _state = DataState.error(e.toString());
    }
    notifyListeners();
  }

  // CREATE
  Future<void> createProgram({required String name, String? nickname}) async {
    try {
      final newDraft = Program(name: name, nickname: nickname);

      await _repository.createProgram(newDraft);

      await loadPrograms();
    } catch (e) {
      _state = DataState.error('Kunne ikke oprette program: $e');
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateProgram({required Program updatedProgram}) async {
    try {
      await _repository.updateProgram(updatedProgram);

      await loadPrograms();
    } catch (e) {
      _state = DataState.error('Kunne ikke opdatere program: $e');
      notifyListeners();
    }
  }

  // 4. DELETE
  Future<void> deleteProgram(String id) async {
    try {
      await _repository.deleteProgram(id);

      await loadPrograms();
    } catch (e) {
      _state = DataState.error('Kunne ikke slette program: $e');
      notifyListeners();
    }
  }
}
