import 'package:flutter/material.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/contact/data/repositories/contact_repository.dart';

import '../../../core/providers/data_state.dart';
import '../data/models/contact_create_request.dart';
import '../data/models/contact_update_request.dart';

class ContactNotifier extends ChangeNotifier {
  final ContactRepository _repository;

  DataState<List<Contact>> _state = const DataState.initial();
  DataState<List<Contact>> get state => _state;

  ContactNotifier(this._repository);

  // READ
  Future<void> loadContacts() async {
    _state = const DataState.loading();
    notifyListeners();

    try {
      // Rettet fra .() til .getContacts()
      final contacts = await _repository.getContacts();
      _state = DataState.loaded(contacts);
    } catch (e) {
      _state = DataState.error(e.toString());
    }
    notifyListeners();
  }

  // CREATE
  Future<void> createContact({
    required String name,
    required String phone,
    int? profileId,
  }) async {
    try {
      // Vi bruger din CreateRequest model
      final request = ContactCreateRequest(
        name: name,
        phone: phone,
        profileId: profileId,
      );

      await _repository.createContact(request);

      // Genindlæs listen efter oprettelse
      await loadContacts();
    } catch (e) {
      _state = DataState.error('Kunne ikke oprette kontakt: $e');
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateContact({
    required int id,
    required ContactUpdateRequest request,
  }) async {
    try {
      // Du skal sende både ID og din request videre til repositroy
      await _repository.updateContact(id, request);

      // Genindlæs listen for at afspejle ændringerne i UI
      await loadContacts();
    } catch (e) {
      _state = DataState.error('Kunne ikke opdatere kontakt: $e');
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteContact(int id) async {
    try {
      await _repository.deleteContact(id);

      await loadContacts();
    } catch (e) {
      _state = DataState.error('Kunne ikke slette kontakt: $e');
      notifyListeners();
    }
  }
}
