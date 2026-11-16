import 'package:flutter/services.dart';

import '../data/step1_business_data.dart';

/// EIN `XX-XXXXXXX` and SSN `XXX-XX-XXXX`. Both are 9 digits.
const taxIdDigits = 9;

/// Digits only, e.g. "12-3456789" -> "123456789".
String taxIdDigitsOf(String input) => input.replaceAll(RegExp(r'\D'), '');

/// Whether [input] is a complete EIN or SSN, with or without dashes.
bool isValidTaxId(String input, TaxIdKind kind) {
  final pattern = switch (kind) {
    TaxIdKind.ein => RegExp(r'^\d{2}-?\d{7}$'),
    TaxIdKind.ssn => RegExp(r'^\d{3}-?\d{2}-?\d{4}$'),
  };
  return pattern.hasMatch(input.trim());
}

/// Adds dashes to (up to 9) digits, e.g. "123456789" -> "12-3456789" (EIN).
String formatTaxId(String digits, TaxIdKind kind) {
  final dashesAfter = switch (kind) {
    TaxIdKind.ein => const {2},
    TaxIdKind.ssn => const {3, 5},
  };
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length && i < taxIdDigits; i++) {
    if (dashesAfter.contains(i)) buffer.write('-');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Keeps digits only and inserts the dashes for [kind] while typing.
class TaxIdInputFormatter extends TextInputFormatter {
  TaxIdInputFormatter(this.kind);

  final TaxIdKind kind;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = formatTaxId(taxIdDigitsOf(newValue.text), kind);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
