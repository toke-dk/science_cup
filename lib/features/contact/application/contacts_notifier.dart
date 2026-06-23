import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/contact/application/contact_repository_provider.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/contact/data/models/contact_create_request.dart';
import 'package:science_cup_app/features/contact/data/models/contact_update_request.dart';

part 'contacts_notifier.g.dart';

@riverpod
class ContactsNotifier extends _$ContactsNotifier {
  @override
  Future<List<Contact>> build() async {
    final repo = ref.read(contactRepositoryProvider);
    return repo.getContacts();
  }

  // CREATE
  Future<void> createContact({
    required String name,
    required String phone,
    int? profileId,
  }) async {
    final repo = ref.read(contactRepositoryProvider);

    final request = ContactCreateRequest(
      name: name,
      phone: phone,
      profileId: profileId,
    );
    debugPrint('HER }');

    await repo.createContact(request);
    debugPrint('HER HER}');

    if (!ref.mounted) return;

    ref.invalidateSelf();
  }

  // UPDATE
  Future<void> updateContact({
    required int id,
    required ContactUpdateRequest request,
  }) async {
    final repo = ref.read(contactRepositoryProvider);

    await repo.updateContact(id, request);

    ref.invalidateSelf();
  }

  // DELETE
  Future<void> deleteContact(int id) async {
    final repo = ref.read(contactRepositoryProvider);

    await repo.deleteContact(id);

    ref.invalidateSelf();
  }
}
