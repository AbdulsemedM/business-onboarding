// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step2_documents_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartnerDocuments _$PartnerDocumentsFromJson(Map<String, dynamic> json) =>
    _PartnerDocuments(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      idType: $enumDecodeNullable(_$PersonalIdTypeEnumMap, json['idType']),
      idDocument: json['idDocument'] == null
          ? null
          : UploadedDocument.fromJson(
              json['idDocument'] as Map<String, dynamic>,
            ),
      idShowsPoBox: json['idShowsPoBox'] as bool? ?? false,
      homeUtilityBill: json['homeUtilityBill'] == null
          ? null
          : UploadedDocument.fromJson(
              json['homeUtilityBill'] as Map<String, dynamic>,
            ),
      homeUtilityBillDate: json['homeUtilityBillDate'] == null
          ? null
          : DateTime.parse(json['homeUtilityBillDate'] as String),
    );

Map<String, dynamic> _$PartnerDocumentsToJson(_PartnerDocuments instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'idType': _$PersonalIdTypeEnumMap[instance.idType],
      'idDocument': instance.idDocument?.toJson(),
      'idShowsPoBox': instance.idShowsPoBox,
      'homeUtilityBill': instance.homeUtilityBill?.toJson(),
      'homeUtilityBillDate': instance.homeUtilityBillDate?.toIso8601String(),
    };

const _$PersonalIdTypeEnumMap = {
  PersonalIdType.governmentId: 'governmentId',
  PersonalIdType.driversLicense: 'driversLicense',
  PersonalIdType.passport: 'passport',
};

_Step2DocumentsData _$Step2DocumentsDataFromJson(
  Map<String, dynamic> json,
) => _Step2DocumentsData(
  partners:
      (json['partners'] as List<dynamic>?)
          ?.map((e) => PartnerDocuments.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [PartnerDocuments(id: Step2DocumentsData.firstPartnerId)],
  registrationType: $enumDecodeNullable(
    _$RegistrationDocTypeEnumMap,
    json['registrationType'],
  ),
  businessRegistration: json['businessRegistration'] == null
      ? null
      : UploadedDocument.fromJson(
          json['businessRegistration'] as Map<String, dynamic>,
        ),
  irsType: $enumDecodeNullable(_$IrsDocTypeEnumMap, json['irsType']),
  irsRegistration: json['irsRegistration'] == null
      ? null
      : UploadedDocument.fromJson(
          json['irsRegistration'] as Map<String, dynamic>,
        ),
  licenseCategory: $enumDecodeNullable(
    _$LicenseCategoryEnumMap,
    json['licenseCategory'],
  ),
  licenseType: $enumDecodeNullable(_$LicenseTypeEnumMap, json['licenseType']),
  license: json['license'] == null
      ? null
      : UploadedDocument.fromJson(json['license'] as Map<String, dynamic>),
  businessUtilityBill: json['businessUtilityBill'] == null
      ? null
      : UploadedDocument.fromJson(
          json['businessUtilityBill'] as Map<String, dynamic>,
        ),
  businessUtilityBillDate: json['businessUtilityBillDate'] == null
      ? null
      : DateTime.parse(json['businessUtilityBillDate'] as String),
  exteriorPhoto: json['exteriorPhoto'] == null
      ? null
      : UploadedDocument.fromJson(
          json['exteriorPhoto'] as Map<String, dynamic>,
        ),
  interiorLayoutPhoto: json['interiorLayoutPhoto'] == null
      ? null
      : UploadedDocument.fromJson(
          json['interiorLayoutPhoto'] as Map<String, dynamic>,
        ),
  checkoutPhoto: json['checkoutPhoto'] == null
      ? null
      : UploadedDocument.fromJson(
          json['checkoutPhoto'] as Map<String, dynamic>,
        ),
  additionalPhoto: json['additionalPhoto'] == null
      ? null
      : UploadedDocument.fromJson(
          json['additionalPhoto'] as Map<String, dynamic>,
        ),
  usesTradeName: json['usesTradeName'] as bool? ?? false,
  tradeName: json['tradeName'] as String?,
  dbaDocument: json['dbaDocument'] == null
      ? null
      : UploadedDocument.fromJson(json['dbaDocument'] as Map<String, dynamic>),
  subleaseAgreement: json['subleaseAgreement'] == null
      ? null
      : UploadedDocument.fromJson(
          json['subleaseAgreement'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$Step2DocumentsDataToJson(
  _Step2DocumentsData instance,
) => <String, dynamic>{
  'partners': instance.partners.map((e) => e.toJson()).toList(),
  'registrationType': _$RegistrationDocTypeEnumMap[instance.registrationType],
  'businessRegistration': instance.businessRegistration?.toJson(),
  'irsType': _$IrsDocTypeEnumMap[instance.irsType],
  'irsRegistration': instance.irsRegistration?.toJson(),
  'licenseCategory': _$LicenseCategoryEnumMap[instance.licenseCategory],
  'licenseType': _$LicenseTypeEnumMap[instance.licenseType],
  'license': instance.license?.toJson(),
  'businessUtilityBill': instance.businessUtilityBill?.toJson(),
  'businessUtilityBillDate': instance.businessUtilityBillDate
      ?.toIso8601String(),
  'exteriorPhoto': instance.exteriorPhoto?.toJson(),
  'interiorLayoutPhoto': instance.interiorLayoutPhoto?.toJson(),
  'checkoutPhoto': instance.checkoutPhoto?.toJson(),
  'additionalPhoto': instance.additionalPhoto?.toJson(),
  'usesTradeName': instance.usesTradeName,
  'tradeName': instance.tradeName,
  'dbaDocument': instance.dbaDocument?.toJson(),
  'subleaseAgreement': instance.subleaseAgreement?.toJson(),
};

const _$RegistrationDocTypeEnumMap = {
  RegistrationDocType.articlesOfOrganization: 'articlesOfOrganization',
  RegistrationDocType.articlesOfIncorporation: 'articlesOfIncorporation',
};

const _$IrsDocTypeEnumMap = {
  IrsDocType.einForm: 'einForm',
  IrsDocType.ss4Letter: 'ss4Letter',
  IrsDocType.recentTaxReturn: 'recentTaxReturn',
};

const _$LicenseCategoryEnumMap = {
  LicenseCategory.general: 'general',
  LicenseCategory.industry: 'industry',
  LicenseCategory.propertySafety: 'propertySafety',
  LicenseCategory.transportation: 'transportation',
};

const _$LicenseTypeEnumMap = {
  LicenseType.generalBusinessLicense: 'generalBusinessLicense',
  LicenseType.salesTaxPermit: 'salesTaxPermit',
  LicenseType.foodLicense: 'foodLicense',
  LicenseType.liquorLicense: 'liquorLicense',
  LicenseType.tobaccoLicense: 'tobaccoLicense',
  LicenseType.lotteryLicense: 'lotteryLicense',
  LicenseType.healthDeptPermit: 'healthDeptPermit',
  LicenseType.certificateOfOccupancy: 'certificateOfOccupancy',
  LicenseType.fireInspection: 'fireInspection',
  LicenseType.foodInspection: 'foodInspection',
  LicenseType.dotRegistration: 'dotRegistration',
  LicenseType.commercialAutoInsurance: 'commercialAutoInsurance',
  LicenseType.commercialVehicleRegistration: 'commercialVehicleRegistration',
};
