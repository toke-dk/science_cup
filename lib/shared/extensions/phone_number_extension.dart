import 'package:phone_numbers_parser/phone_numbers_parser.dart';

extension PhoneNumberExtension on String? {
  PhoneNumber? get tryParsePhoneNumber {
    if (this == null) {
      return null;
    }
    try {
      return PhoneNumber.parse(this!);
    } catch (e) {
      return null;
    }
  }
}
