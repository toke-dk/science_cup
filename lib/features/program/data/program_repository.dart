import 'package:science_cup_app/features/program/data/program.dart';
import 'package:supabase/supabase.dart';

class ProgramRepository {
  final SupabaseClient _supabase;

  ProgramRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<Program> createProgram(Program program) async {
    try {
      final jsonToSend = program.toJson();

      final response = await _supabase
          .from('programs')
          .insert(jsonToSend)
          .select()
          .single();

      return Program.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette gruppe: $e');
    }
  }

  Future<List<Program>> getPrograms() async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('programs')
          .select()
          .order('name', ascending: true);

      return response.map((json) => Program.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kunne ikke hente programmer: $e');
    }
  }
  Future<Program> updateProgram(Program program) async {
    if (program.id == null) {
      throw Exception('Program ID er påkrævet for at opdatere.');
    }
    try {
      final response = await _supabase
          .from('programs')
          .update(program.toJson())
          .eq('id', program.id!) // <-- Matcher på UUID
          .select()
          .single();

      return Program.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere program: $e');
    }
  }

  Future<void> deleteProgram(String id) async {
    try {
      await _supabase.from('programs').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kunne ikke slette program: $e');
    }
  }
}
