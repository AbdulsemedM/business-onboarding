import 'package:freezed_annotation/freezed_annotation.dart';

part 'step1_business_data.freezed.dart';
part 'step1_business_data.g.dart';

/// Backend tenure codes: `LEASED` / `OWNED`.
enum PropertyStatus {
  lease('LEASED'),
  own('OWNED');

  const PropertyStatus(this.apiCode);
  final String apiCode;
}

/// Backend `taxIdentifierKinds` codes used by the app.
enum TaxIdKind {
  ein('EIN'),
  ssn('SSN');

  const TaxIdKind(this.apiCode);
  final String apiCode;
}

/// Backend `taxClassifications` codes.
enum TaxDesignation {
  /// Sole proprietorship / single-member LLC filing under its own EIN.
  llcSoleEin('LLC_SINGLE_MEMBER_EIN', TaxIdKind.ein),

  /// Sole proprietorship / single-member LLC reported on the owner's SSN.
  llcSoleSsn('LLC_SINGLE_MEMBER_SSN', TaxIdKind.ssn),

  /// LLC taxed as a C-Corporation (IRS Form 8832).
  llcCCorp('LLC_C_CORP_ELECTION', TaxIdKind.ein),

  /// LLC taxed as an S-Corporation (IRS Form 2553).
  llcSCorp('LLC_S_CORP_ELECTION', TaxIdKind.ein);

  const TaxDesignation(this.apiCode, this.taxIdKind);
  final String apiCode;

  /// Which number the backend expects in `identifierValue`.
  final TaxIdKind taxIdKind;
}

/// Step 1 answers. Everything is nullable because the draft is saved while
/// the user is still filling it in.
///
/// Mirrors the backend's `initial-business-details` request
/// (see docs/api/README.md).
@freezed
abstract class Step1BusinessData with _$Step1BusinessData {
  const factory Step1BusinessData({
    /// Primary owner (backend `primaryOwner`, always `INDIVIDUAL`). They are
    /// partner 1 in Step 2.
    String? ownerFirstName,
    String? ownerLastName,

    /// ISO weekdays: 1 = Monday ... 7 = Sunday.
    @Default(<int>[]) List<int> openDays,

    /// Minutes since midnight.
    int? opensAt,
    int? closesAt,

    // Business location address. Backend requires line 1, city and country.
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? region,
    String? postalCode,
    @Default('US') String countryCode,

    /// The business subleases its space (backend `subtenant`). Step 2 then
    /// asks for the sublease agreement.
    @Default(false) bool subtenant,

    int? yearsAtLocation,
    int? monthsAtLocation,
    PropertyStatus? businessProperty,
    PropertyStatus? residentialProperty,

    /// Optional (backend `monthsAtResidence`).
    int? yearsAtResidence,
    int? monthsAtResidence,

    // Landlords are only used while the matching property is leased. Kept
    // (but hidden) if the user switches to "Own", so a mis-tap doesn't lose
    // their input.
    // TODO(review): leave them out of the submission when not leased.
    String? businessLandlordName,
    @Default('US') String businessLandlordPhoneCountry,
    String? businessLandlordPhoneNumber,
    String? residentialLandlordName,
    @Default('US') String residentialLandlordPhoneCountry,
    String? residentialLandlordPhoneNumber,

    // TODO(backend): switch to a searchable list if the API provides banks.
    String? bankName,
    TaxDesignation? taxDesignation,

    /// EIN or SSN digits only, no dashes. Which one depends on
    /// [taxDesignation]. Cleared when that changes kind.
    String? taxId,
  }) = _Step1BusinessData;

  const Step1BusinessData._();

  factory Step1BusinessData.fromJson(Map<String, dynamic> json) =>
      _$Step1BusinessDataFromJson(json);

  /// "First Last" from what has been entered so far. Empty if neither.
  String get ownerFullName =>
      [ownerFirstName, ownerLastName].nonNulls.join(' ');

  bool get businessLandlordRequired => businessProperty == PropertyStatus.lease;

  bool get residentialLandlordRequired =>
      residentialProperty == PropertyStatus.lease;
}
