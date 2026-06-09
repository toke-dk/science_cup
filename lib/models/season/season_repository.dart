import 'package:science_cup_app/models/season/season.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeasonRepository {
  final SupabaseClient _supabase;

  SeasonRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  // 1. CREATE (Opret Sæson)
  Future<Season> createSeason(Season season) async {
    try {
      final jsonToSend = season.toJson();

      final response = await _supabase
          .from('seasons')
          .insert(jsonToSend)
          .select()
          .single();

      return Season.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette sæson: $e');
    }
  }

  // 2. READ (Hent Sæsoner)
  Future<List<Season>> getAllSeasons() async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('seasons')
          .select()
          .order('created_at', ascending: false); // Nyeste først

      return response.map((json) => Season.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kunne ikke hente sæsoner: $e');
    }
  }

  // 3. UPDATE (Opdater Sæson)
  Future<Season> updateSeason(Season season) async {
    if (season.id == null) {
      throw Exception('Sæson ID er påkrævet for at opdatere.');
    }
    try {
      final response = await _supabase
          .from('seasons')
          .update(season.toJson())
          .eq('id', season.id!) // <-- Matcher på UUID
          .select()
          .single();

      return Season.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere sæson: $e');
    }
  }

  // 4. DELETE (Slet Sæson)
  Future<void> deleteSeason(String id) async {
    try {
      await _supabase
          .from('seasons')
          .delete()
          .eq('id', id); // <-- Matcher på UUID

      // Bemærk: Takket være 'ON DELETE CASCADE' i din SQL,
      // slettes alle tilhørende hold og kampe automatisk i databasen!
    } catch (e) {
      throw Exception('Kunne ikke slette sæson: $e');
    }
  }
}