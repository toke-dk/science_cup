import 'package:science_cup_app/features/contact/data/contact.dart';
import 'package:science_cup_app/features/contact/data/contact_update_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'contact_insert_request.dart';

class ContactRepository {
  final SupabaseClient _supabase;

  ContactRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Opretter en ny kontakt
  Future<Contact> createContact(ContactCreateRequest request) async {
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

  /// Henter alle kontakter
  Future<List<Contact>> getContacts() async {
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('contacts')
          .select();

      // Her er rettet fra Program.fromJson til Contact.fromJson
      return response.map((json) => Contact.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Kunne ikke hente kontakter: $e');
    }
  }

  /// Opdaterer en eksisterende kontakt
  Future<Contact> updateContact(int id, ContactUpdateRequest updateRequest) async {
    try {
      final response = await _supabase
          .from('contacts')
          .update(updateRequest.toJson())
          .eq('id', id)
          .select()
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke opdatere kontakt: $e');
    }
  }

  /// Sletter en kontakt
  Future<void> deleteContact(int id) async {
    try {
      await _supabase.from('contacts').delete().eq('id', id);
    } catch (e) {
      throw Exception('Kunne ikke slette kontakt: $e');
    }
  }
}