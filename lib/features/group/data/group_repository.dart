import 'package:science_cup_app/features/group/data/group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupRepository {
  final SupabaseClient _supabase;

  GroupRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

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

  Future<void> deleteGroup(String id) async {
    try {
      await _supabase.from('groups').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kunne ikke slette gruppe: $e');
    }
  }
}
