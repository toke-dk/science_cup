import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/program/application/program_repository_provider.dart';
import 'package:science_cup_app/features/program/data/program.dart';

part 'program_notifier.g.dart';

@riverpod
class ProgramNotifier extends _$ProgramNotifier {
  @override
  Future<List<Program>> build() async {
    final repository = ref.read(programRepositoryProvider);
    return repository.getPrograms();
  }

  // CREATE
  Future<void> createProgram({required String name, String? nickname}) async {
    final repository = ref.read(programRepositoryProvider);
    final newProgram = Program(name: name, nickname: nickname);
    await repository.createProgram(newProgram);
    ref.invalidateSelf(); // genindlæs listen
  }

  // UPDATE
  Future<void> updateProgram({required Program updatedProgram}) async {
    final repository = ref.read(programRepositoryProvider);
    await repository.updateProgram(updatedProgram);
    ref.invalidateSelf();
  }

  // DELETE
  Future<void> deleteProgram(String id) async {
    final repository = ref.read(programRepositoryProvider);
    await repository.deleteProgram(id);
    ref.invalidateSelf();
  }
}
