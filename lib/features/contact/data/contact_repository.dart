import 'package:science_cup_app/features/contact/data/contact.dart';
import 'package:science_cup_app/features/contact/data/contact_insert_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactRepository {
  final SupabaseClient _supabase;

  ContactRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<Contact> createContact(ContactCreateRequest contact) async {
    try {
      final jsonToSend = contact.toJson();

      final response = await _supabase
          .from('contacts')
          .insert(jsonToSend)
          .select()
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      throw Exception('Kunne ikke oprette hold: $e');
    }
  }
}
