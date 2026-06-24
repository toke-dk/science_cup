import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/contact/application/contact_repository_provider.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/features/contact/data/models/contact_write_request.dart';

part 'contacts_notifier.g.dart';

@riverpod
class ContactsNotifier extends _$ContactsNotifier {
  @override
  Future<List<Contact>> build() async {
    final repo = ref.read(contactRepositoryProvider);
    return repo.getContacts();
  }

  // CREATE hvis eksisterer ellers UPDATE
  Future<void> saveContact({
    int? contactId,
    required String name,
    required String phone,
    int? profileId,
  }) async {
    final repo = ref.read(contactRepositoryProvider);
    final request = ContactWriteRequest(
      name: name,
      phone: phone,
      profileId: profileId,
    );

    if (contactId != null) {
      print("Updating contact with id: $contactId");
      await repo.updateContact(contactId, request);
    } else {
      print("Creating new contact");
      await repo.createContact(request);
    }

    if (!ref.mounted) return;

    ref.invalidateSelf();
  }

  // DELETE
  Future<void> deleteContact(int id) async {
    final repo = ref.read(contactRepositoryProvider);

    await repo.deleteContact(id);

    ref.invalidateSelf();
  }
}
