import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/program/application/program_repository_provider.dart';
import 'package:science_cup_app/features/program/data/models/program.dart';
import 'package:science_cup_app/features/program/data/models/program_write_request.dart';

part 'program_notifier.g.dart';

@riverpod
class ProgramNotifier extends _$ProgramNotifier {
  @override
  Future<List<Program>> build() async {
    final repository = ref.read(programRepositoryProvider);
    return repository.getPrograms();
  }

  // CREATE
  Future<void> saveProgram({
    int? id,
    required String name,
    String? nickname,
  }) async {
    final repository = ref.read(programRepositoryProvider);

    final request = ProgramWriteRequest(id: id, name: name, nickname: nickname);

    if (id != null) {
      await repository.updateProgram(request);
    } else {
      await repository.createProgram(request);
    }

    if (!ref.mounted) return;

    ref.invalidateSelf(); // genindlæs listen
  }

  // DELETE
  Future<void> deleteProgram(int id) async {
    final repository = ref.read(programRepositoryProvider);
    await repository.deleteProgram(id);
    ref.invalidateSelf();
  }
}
