import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';
import 'package:business_onboarding/features/onboarding/step1_business/logic/tax_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EIN accepts XX-XXXXXXX with or without the dash', () {
    expect(isValidTaxId('12-3456789', TaxIdKind.ein), isTrue);
    expect(isValidTaxId('123456789', TaxIdKind.ein), isTrue);
    expect(isValidTaxId('123-45-6789', TaxIdKind.ein), isFalse);
    expect(isValidTaxId('12-345678', TaxIdKind.ein), isFalse);
    expect(isValidTaxId('', TaxIdKind.ein), isFalse);
  });

  test('SSN accepts XXX-XX-XXXX with or without dashes', () {
    expect(isValidTaxId('123-45-6789', TaxIdKind.ssn), isTrue);
    expect(isValidTaxId('123456789', TaxIdKind.ssn), isTrue);
    expect(isValidTaxId('12-3456789', TaxIdKind.ssn), isFalse);
    expect(isValidTaxId('123-45-678', TaxIdKind.ssn), isFalse);
  });

  test('formats digits for each kind, including partial input', () {
    expect(formatTaxId('123456789', TaxIdKind.ein), '12-3456789');
    expect(formatTaxId('123456789', TaxIdKind.ssn), '123-45-6789');
    expect(formatTaxId('12', TaxIdKind.ein), '12');
    expect(formatTaxId('123', TaxIdKind.ein), '12-3');
    expect(formatTaxId('1234', TaxIdKind.ssn), '123-4');
    expect(formatTaxId('1234567890', TaxIdKind.ein), '12-3456789');
  });

  test('input formatter drops non-digits and inserts dashes', () {
    final formatter = TaxIdInputFormatter(TaxIdKind.ssn);
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '12a3 45-6789'),
    );
    expect(result.text, '123-45-6789');
    expect(result.selection.baseOffset, result.text.length);
  });

  test('designations map to backend codes and ID kinds', () {
    expect(TaxDesignation.llcSoleEin.apiCode, 'LLC_SINGLE_MEMBER_EIN');
    expect(TaxDesignation.llcSoleSsn.apiCode, 'LLC_SINGLE_MEMBER_SSN');
    expect(TaxDesignation.llcCCorp.apiCode, 'LLC_C_CORP_ELECTION');
    expect(TaxDesignation.llcSCorp.apiCode, 'LLC_S_CORP_ELECTION');
    expect(TaxDesignation.llcSoleSsn.taxIdKind, TaxIdKind.ssn);
    expect(
      TaxDesignation.values.where((d) => d.taxIdKind == TaxIdKind.ein),
      hasLength(3),
    );
  });
}
