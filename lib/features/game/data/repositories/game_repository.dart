import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/game/data/models/write_game_request.dart';
import 'package:supabase/supabase.dart';

class GameRepository {
  final SupabaseClient _supabase;

  GameRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // TODO Contact with teams. (Lav to nye repositories)

  /// Opretter en ny kontakt
  Future<Contact> createGame(WriteGameRequest request) async {
    try {
      final response = await _supabase
          .from('contacts')
          .insert(request.toJson())
          .select()
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette kontakt: $e');
    }
  }
}
