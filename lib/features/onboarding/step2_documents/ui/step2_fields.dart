/// Form field names for Step 2. Also used as keys in widget tests.
abstract final class Step2Fields {
  static String partnerFirstName(String partnerId) => '$partnerId.firstName';
  static String partnerLastName(String partnerId) => '$partnerId.lastName';
  static String idType(String partnerId) => '$partnerId.idType';
  static String idDocument(String partnerId) => '$partnerId.idDocument';
  static String homeBill(String partnerId) => '$partnerId.homeBill';
  static String homeBillDate(String partnerId) => '$partnerId.homeBillDate';

  static const registrationType = 'registrationType';
  static const businessRegistration = 'businessRegistration';
  static const irsType = 'irsType';
  static const irsRegistration = 'irsRegistration';
  static const licenseCategory = 'licenseCategory';
  static const licenseType = 'licenseType';
  static const license = 'license';
  static const businessBill = 'businessBill';
  static const businessBillDate = 'businessBillDate';
  static const exteriorPhoto = 'exteriorPhoto';
  static const interiorLayoutPhoto = 'interiorLayoutPhoto';
  static const checkoutPhoto = 'checkoutPhoto';
  static const additionalPhoto = 'additionalPhoto';
  static const tradeName = 'tradeName';
  static const dbaDocument = 'dbaDocument';
  static const subleaseAgreement = 'subleaseAgreement';
}
