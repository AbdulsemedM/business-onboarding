import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Parses an ISO 3166 alpha-2 code like "US". Returns null if unknown.
IsoCode? isoCodeFrom(String code) {
  for (final iso in IsoCode.values) {
    if (iso.name == code.toUpperCase()) return iso;
  }
  return null;
}

/// Dial code without the "+", e.g. "1" for US.
String dialCodeFor(IsoCode iso) =>
    PhoneNumber(isoCode: iso, nsn: '').countryCode;

/// Whether [number] (as typed, national or international) is a valid phone
/// number for [country].
bool isValidPhoneNumber(String number, IsoCode country) {
  if (number.trim().isEmpty) return false;
  try {
    return PhoneNumber.parse(number, destinationCountry: country).isValid();
  } on PhoneNumberException {
    return false;
  }
}

/// E.164 form, e.g. "+15551234567", or null if invalid.
String? toE164(String number, IsoCode country) {
  if (!isValidPhoneNumber(number, country)) return null;
  return PhoneNumber.parse(number, destinationCountry: country).international;
}

/// Flag emoji for an ISO alpha-2 code.
String flagEmoji(IsoCode iso) {
  const regionalIndicatorA = 0x1F1E6;
  return String.fromCharCodes(
    iso.name.codeUnits.map((c) => regionalIndicatorA + c - 0x41),
  );
}
