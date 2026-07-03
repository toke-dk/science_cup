import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/group/data/models/group_board_state.dart';
import 'package:science_cup_app/features/group/data/models/group_with_teams.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:supabase/supabase.dart';

class GroupRepository {
  final SupabaseClient _supabase;

  GroupRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<Group> createGroup(Group group) async {
    try {
      final jsonToSend = group.toJson();

      final response = await _supabase
          .from('groups')
          .insert(jsonToSend)
          .select()
          .single();

      return Group.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette gruppe: $e');
    }
  }

  Future<List<Group>> getGroupsForSeason(int seasonId) async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('groups')
          .select()
          .eq("season_id", seasonId)
          .order('name', ascending: true);

      return response.map((json) => Group.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kunne ikke hente grupper: $e');
    }
  }

  Future<Group> updateGroup(Group group) async {
    if (group.id == null) {
      throw Exception('Group ID er påkrævet for at opdatere.');
    }
    try {
      final response = await _supabase
          .from('groups')
          .update(group.toJson())
          .eq('id', group.id!) // <-- Matcher på UUID
          .select()
          .single();

      return Group.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere gruppe: $e');
    }
  }

  Future<void> deleteGroup(int id) async {
    try {
      await _supabase.from('groups').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kunne ikke slette gruppe: $e');
    }
  }

  Future<GroupBoardState> getGroupBoard(int seasonId) async {
    try {
      // 1. Groups + teams
      final groupsResponse = await _supabase
          .from('groups')
          .select('*, teams(*)')
          .eq('season_id', seasonId)
          .order('name', ascending: true);

      // 2. Unassigned teams
      final unassignedResponse = await _supabase
          .from('teams')
          .select('*')
          .eq('season_id', seasonId)
          .isFilter('group_id', null);

      // 3. Map groups
      final groups = groupsResponse.map<GroupWithTeams>((json) {
        return GroupWithTeams(
          group: Group.fromJson(json),
          teams: (json['teams'] as List<dynamic>)
              .map((t) => Team.fromJson(t))
              .toList(),
        );
      }).toList();

      // 4. Map unassigned
      final unassignedTeams = unassignedResponse
          .map((t) => Team.fromJson(t))
          .toList();

      // 5. Return samlet state
      return GroupBoardState(
        groupsWithTeams: groups,
        unassignedTeams: unassignedTeams,
      );
    } catch (e) {
      throw Exception('Kunne ikke hente group board: $e');
    }
  }

  Future<void> updateGroupTeams(int groupId, List<int> allTeamIds) async {
    try {
      // 1. reset (source of truth)
      await _supabase
          .from('teams')
          .update({'group_id': null})
          .eq('group_id', groupId);

      // 2. apply new state
      if (allTeamIds.isNotEmpty) {
        await _supabase
            .from('teams')
            .update({'group_id': groupId})
            .inFilter('id', allTeamIds);
      }
    } catch (e) {
      throw Exception('Kunne ikke opdatere gruppe teams: $e');
    }
  }
}
