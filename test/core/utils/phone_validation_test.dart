import 'package:business_onboarding/core/utils/phone_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../helpers/sample_data.dart';

void main() {
  group('isValidPhoneNumber', () {
    test('accepts a valid US number in common formats', () {
      expect(isValidPhoneNumber(validUsPhone, IsoCode.US), isTrue);
      expect(isValidPhoneNumber('(650) 253-0000', IsoCode.US), isTrue);
      expect(isValidPhoneNumber('+1 650 253 0000', IsoCode.US), isTrue);
    });

    test('rejects empty, short, and garbage input', () {
      expect(isValidPhoneNumber('', IsoCode.US), isFalse);
      expect(isValidPhoneNumber('   ', IsoCode.US), isFalse);
      expect(isValidPhoneNumber('12345', IsoCode.US), isFalse);
      expect(isValidPhoneNumber('+++', IsoCode.US), isFalse);
    });

    test('checks the number against the selected country', () {
      expect(isValidPhoneNumber(validUsPhone, IsoCode.GB), isFalse);
      expect(isValidPhoneNumber('020 7946 0958', IsoCode.GB), isTrue);
    });
  });

  test('toE164 formats valid numbers and rejects invalid ones', () {
    expect(toE164('(650) 253-0000', IsoCode.US), '+16502530000');
    expect(toE164('123', IsoCode.US), isNull);
  });

  test('isoCodeFrom is case-insensitive and handles unknown codes', () {
    expect(isoCodeFrom('us'), IsoCode.US);
    expect(isoCodeFrom('GB'), IsoCode.GB);
    expect(isoCodeFrom('XX'), isNull);
  });

  test('every country has a dial code and a flag', () {
    for (final iso in IsoCode.values) {
      expect(dialCodeFor(iso), isNotEmpty, reason: iso.name);
      expect(flagEmoji(iso).runes.length, 2, reason: iso.name);
    }
    expect(dialCodeFor(IsoCode.US), '1');
    expect(flagEmoji(IsoCode.US), '\u{1F1FA}\u{1F1F8}');
  });
}
