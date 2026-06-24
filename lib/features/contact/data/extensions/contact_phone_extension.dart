import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:science_cup_app/features/contact/data/models/contact.dart';
import 'package:science_cup_app/shared/extensions/phone_number_extension.dart';

extension ContactPhoneExtension on Contact {
  PhoneNumber? get phoneNumber => phone?.tryParsePhoneNumber;

  // Dette bør aldrig kopieres til udklipsholder, det er kun til UX. Kopier Contact.phone i stedet
  String get formattedPhoneNumber {
    if (phoneNumber == null || phoneNumber?.countryCode == null) {
      return "?";
    }
    return "+${phoneNumber!.countryCode} ${phoneNumber!.formatNsn()}";
  }
}
