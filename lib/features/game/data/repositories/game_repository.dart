import 'package:science_cup_app/features/game/data/models/game.dart';
import 'package:science_cup_app/features/game/data/models/write_game_request.dart';
import 'package:supabase/supabase.dart';

class GameRepository {
  final SupabaseClient _supabase;

  GameRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // TODO Contact with teams. (Lav to nye repositories)

  /// Opretter en ny kamp
  Future<Game> createGame(WriteGameRequest request) async {
    try {
      final response = await _supabase
          .from('games')
          .insert(request.toJson())
          .select()
          .single();

      return Game.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette kamp: $e');
    }
  }

  /// Opdaterer en eksisterende kamp
  Future<Game> updateGame(WriteGameRequest request) async {
    if (request.id == null) {
      throw Exception('Game ID er påkrævet for at opdatere.');
    }
    try {
      final response = await _supabase
          .from('games')
          .update(request.toJson())
          .eq('id', request.id!)
          .select()
          .single();

      return Game.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere kamp: $e');
    }
  }
}
