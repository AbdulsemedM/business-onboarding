import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../documents/data/models/uploaded_document.dart';

part 'step2_documents_data.freezed.dart';
part 'step2_documents_data.g.dart';

/// Backend `identificationDocumentTypes`.
enum PersonalIdType {
  governmentId('GOVERNMENT_ID'),
  driversLicense('DRIVERS_LICENSE'),
  passport('PASSPORT');

  const PersonalIdType(this.apiCode);
  final String apiCode;
}

/// Backend `businessRegistration.documentTypes`.
enum RegistrationDocType {
  articlesOfOrganization('ARTICLES_OF_ORGANIZATION'),
  articlesOfIncorporation('ARTICLES_OF_INCORPORATION');

  const RegistrationDocType(this.apiCode);
  final String apiCode;
}

/// Backend `irsRegistration.documentTypes`. Only one is needed.
enum IrsDocType {
  einForm('EIN_FORM'),
  ss4Letter('IRS_SS4_LETTER'),
  recentTaxReturn('RECENT_TAX_RETURN');

  const IrsDocType(this.apiCode);
  final String apiCode;
}

/// Groups the license types so the list is short enough to choose from.
enum LicenseCategory { general, industry, propertySafety, transportation }

/// Backend `businessLicensesAndPermits.documentTypes`. Only one is needed.
enum LicenseType {
  generalBusinessLicense('GENERAL_BUSINESS_LICENSE', LicenseCategory.general),
  salesTaxPermit('SALES_TAX_PERMIT', LicenseCategory.general),
  foodLicense('FOOD_LICENSE', LicenseCategory.industry),
  liquorLicense('LIQUOR_LICENSE', LicenseCategory.industry),
  tobaccoLicense('TOBACCO_LICENSE', LicenseCategory.industry),
  lotteryLicense('LOTTERY_LICENSE', LicenseCategory.industry),
  healthDeptPermit('HEALTH_DEPT_PERMIT', LicenseCategory.industry),
  certificateOfOccupancy(
    'CERTIFICATE_OF_OCCUPANCY',
    LicenseCategory.propertySafety,
  ),
  fireInspection('FIRE_INSPECTION', LicenseCategory.propertySafety),
  foodInspection('FOOD_INSPECTION', LicenseCategory.propertySafety),
  dotRegistration('DOT_REGISTRATION', LicenseCategory.transportation),
  commercialAutoInsurance(
    'COMMERCIAL_AUTO_INSURANCE',
    LicenseCategory.transportation,
  ),
  commercialVehicleRegistration(
    'COMMERCIAL_VEHICLE_REGISTRATION',
    LicenseCategory.transportation,
  );

  const LicenseType(this.apiCode, this.category);
  final String apiCode;
  final LicenseCategory category;
}

/// Backend document type codes for the slots with a single, fixed type.
/// Slots where the user picks the type use that enum's `apiCode`.
abstract final class DocumentTypes {
  static const homeUtilityBill = 'RESIDENTIAL_UTILITY_BILL';
  static const businessUtilityBill = 'BUSINESS_UTILITY_BILL';
  static const photoExterior = 'PHOTO_EXTERIOR_ENTRANCE';
  static const photoInteriorLayout = 'PHOTO_INTERIOR_LAYOUT';
  static const photoCheckout = 'PHOTO_CHECKOUT_AREA';
  static const photoAdditional = 'PHOTO_INTERIOR_ADDITIONAL';
  static const dbaDocumentation = 'DBA_DOCUMENTATION';
  static const subleaseAgreement = 'SUBLEASE_AGREEMENT';
}

/// ID documents for one business partner.
@freezed
abstract class PartnerDocuments with _$PartnerDocuments {
  const factory PartnerDocuments({
    /// Local id used to tell partners apart on the device. Not sent.
    required String id,

    /// Server owner id (backend `ownerId`) once this partner was saved.
    /// Unused for the first partner: that is the Step 1 owner.
    String? ownerId,

    /// Legal name, as on the ID. Personal data: never log it.
    /// Not used for the first partner: that is the owner from Step 1.
    String? firstName,
    String? lastName,
    PersonalIdType? idType,
    UploadedDocument? idDocument,

    /// The ID lists a P.O. Box instead of a street address.
    @Default(false) bool idShowsPoBox,

    // Only needed for a passport or a P.O. Box address. Kept (but hidden)
    // otherwise, so a mis-tap doesn't lose the upload.
    // TODO(review): leave these out of the submission when not required.
    UploadedDocument? homeUtilityBill,
    DateTime? homeUtilityBillDate,
  }) = _PartnerDocuments;

  const PartnerDocuments._();

  factory PartnerDocuments.fromJson(Map<String, dynamic> json) =>
      _$PartnerDocumentsFromJson(json);

  bool get homeUtilityBillRequired =>
      idType == PersonalIdType.passport || idShowsPoBox;
}

/// Step 2 answers. Everything is nullable because the draft is saved while
/// the user is still filling it in.
@freezed
abstract class Step2DocumentsData with _$Step2DocumentsData {
  const factory Step2DocumentsData({
    /// At least one. The first partner is the Step 1 owner (also "Same as
    /// owner" in Step 3) and can't be removed.
    @Default([PartnerDocuments(id: Step2DocumentsData.firstPartnerId)])
    List<PartnerDocuments> partners,

    RegistrationDocType? registrationType,
    UploadedDocument? businessRegistration,

    IrsDocType? irsType,
    UploadedDocument? irsRegistration,

    /// Narrows the [licenseType] list. Changing it clears [licenseType] but
    /// keeps the file.
    LicenseCategory? licenseCategory,
    LicenseType? licenseType,
    UploadedDocument? license,

    UploadedDocument? businessUtilityBill,
    DateTime? businessUtilityBillDate,

    UploadedDocument? exteriorPhoto,
    UploadedDocument? interiorLayoutPhoto,
    UploadedDocument? checkoutPhoto,

    /// Optional fourth photo.
    UploadedDocument? additionalPhoto,

    /// The business uses a trade name (DBA). The backend verifies it from the
    /// photos; DBA documentation is optional.
    @Default(false) bool usesTradeName,

    // Kept (but hidden) if the DBA toggle is turned off.
    // TODO(review): leave them out of the submission when not using a DBA.
    // TODO(backend): no partner endpoint sets the trade name yet.
    String? tradeName,
    UploadedDocument? dbaDocument,

    /// Required while Step 1 says the business is a subtenant. Kept (but
    /// hidden) if that is turned off.
    // TODO(review): leave it out of the submission when not subleasing.
    UploadedDocument? subleaseAgreement,
  }) = _Step2DocumentsData;

  const Step2DocumentsData._();

  factory Step2DocumentsData.fromJson(Map<String, dynamic> json) =>
      _$Step2DocumentsDataFromJson(json);

  static const firstPartnerId = 'partner-1';

  PartnerDocuments get owner => partners.first;

  Step2DocumentsData withPartnerAdded(String id) => copyWith(
    partners: [
      ...partners,
      PartnerDocuments(id: id),
    ],
  );

  Step2DocumentsData withPartnerRemoved(String id) =>
      copyWith(partners: [...partners.where((p) => p.id != id)]);

  Step2DocumentsData withPartnerUpdated(
    String id,
    PartnerDocuments Function(PartnerDocuments partner) change,
  ) => copyWith(
    partners: [for (final p in partners) p.id == id ? change(p) : p],
  );
}
