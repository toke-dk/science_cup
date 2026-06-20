import 'package:science_cup_app/features/team/data/team.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamRepository {
  final SupabaseClient _supabase;

  TeamRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<Team> createTeam(Team team) async {
    try {
      final jsonToSend = team.toJson();

      final response = await _supabase
          .from('teams')
          .insert(jsonToSend)
          .select()
          .single();

      return Team.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette hold: $e');
    }
  }

  Future<List<Team>> getTeamsForSeason(int seasonId) async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('teams')
          .select()
          .eq("season_id", seasonId)
          .order('name', ascending: true);

      return response.map((json) => Team.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kunne ikke hente hold: $e');
    }
  }

  Future<Team> updateTeam(Team team) async {
    if (team.id == null) {
      throw Exception('Team ID er påkrævet for at opdatere.');
    }
    try {
      final response = await _supabase
          .from('teams')
          .update(team.toJson())
          .eq('id', team.id!) // <-- Matcher på UUID
          .select()
          .single();

      return Team.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere hold: $e');
    }
  }

  Future<void> deleteTeam(String id) async {
    try {
      await _supabase.from('teams').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kunne ikke slette hold: $e');
    }
  }

  Future<void> addContactToTeam({
    required int teamId,
    required int contactId,
    required bool isPrimary,
  }) async {
    await _supabase.from('team_contacts').insert({
      'team_id': teamId,
      'contact_id': contactId,
      'is_primary': isPrimary,
    });
  }
}
