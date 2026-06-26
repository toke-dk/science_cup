import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/features/team/data/models/write_team_request.dart';
import 'package:supabase/supabase.dart';

class TeamRepository {
  final SupabaseClient _supabase;

  TeamRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // TODO Team with contacts.

  Future<Team> createTeam(WriteTeamRequest request) async {
    try {
      final jsonToSend = request.toJson();

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
          .select('*, program:programs(*), group:groups(*)')
          .eq("season_id", seasonId)
          .order('name', ascending: true);

      return response.map((json) => Team.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kunne ikke hente hold: $e');
    }
  }

  Future<Team> updateTeam(WriteTeamRequest request) async {
    if (request.id == null) {
      throw Exception('Team ID er påkrævet for at opdatere.');
    }
    try {
      final response = await _supabase
          .from('teams')
          .update(request.toJson())
          .eq('id', request.id!) // <-- Matcher på UUID
          .select()
          .single();

      return Team.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere hold: $e');
    }
  }

  Future<void> deleteTeam(int id) async {
    try {
      await _supabase.from('teams').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kunne ikke slette hold: $e');
    }
  }

  Future<Team> getTeamWithContacts(int teamId) async {
    final response = await _supabase
        .from('teams')
        .select('*, contacts(*), program:programs(*)')
        .eq('id', teamId)
        .single();

    return Team.fromJson(response);
  }

  // Tilføj en kontakt til et team via team_contacts tabellen
  Future<void> addContactToTeam({
    required int teamId,
    required int contactId,
  }) async {
    await _supabase.from('team_contacts').insert({
      'team_id': teamId,
      'contact_id': contactId,
    });
  }

  // Fjern kontakt fra team via team_contacts tabellen
  Future<void> removeContactFromTeam({
    required int teamId,
    required int contactId,
  }) async {
    await _supabase
        .from('team_contacts')
        .delete()
        .eq('team_id', teamId)
        .eq('contact_id', contactId);
  }

  //  Future<void> assignGroupToTeams({
  //    required int groupId,
  //    required List<int> teamIds,
  //  }) async {
  //    await _supabase
  //        .from('teams')
  //        .update({'group_id': groupId})
  //        .inFilter('id', teamIds);
  //  }
}
