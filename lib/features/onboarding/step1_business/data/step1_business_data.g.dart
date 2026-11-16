// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step1_business_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Step1BusinessData _$Step1BusinessDataFromJson(Map<String, dynamic> json) =>
    _Step1BusinessData(
      ownerFirstName: json['ownerFirstName'] as String?,
      ownerLastName: json['ownerLastName'] as String?,
      openDays:
          (json['openDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      opensAt: (json['opensAt'] as num?)?.toInt(),
      closesAt: (json['closesAt'] as num?)?.toInt(),
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      postalCode: json['postalCode'] as String?,
      countryCode: json['countryCode'] as String? ?? 'US',
      subtenant: json['subtenant'] as bool? ?? false,
      yearsAtLocation: (json['yearsAtLocation'] as num?)?.toInt(),
      monthsAtLocation: (json['monthsAtLocation'] as num?)?.toInt(),
      businessProperty: $enumDecodeNullable(
        _$PropertyStatusEnumMap,
        json['businessProperty'],
      ),
      residentialProperty: $enumDecodeNullable(
        _$PropertyStatusEnumMap,
        json['residentialProperty'],
      ),
      yearsAtResidence: (json['yearsAtResidence'] as num?)?.toInt(),
      monthsAtResidence: (json['monthsAtResidence'] as num?)?.toInt(),
      businessLandlordName: json['businessLandlordName'] as String?,
      businessLandlordPhoneCountry:
          json['businessLandlordPhoneCountry'] as String? ?? 'US',
      businessLandlordPhoneNumber:
          json['businessLandlordPhoneNumber'] as String?,
      residentialLandlordName: json['residentialLandlordName'] as String?,
      residentialLandlordPhoneCountry:
          json['residentialLandlordPhoneCountry'] as String? ?? 'US',
      residentialLandlordPhoneNumber:
          json['residentialLandlordPhoneNumber'] as String?,
      bankName: json['bankName'] as String?,
      taxDesignation: $enumDecodeNullable(
        _$TaxDesignationEnumMap,
        json['taxDesignation'],
      ),
      taxId: json['taxId'] as String?,
    );

Map<String, dynamic> _$Step1BusinessDataToJson(
  _Step1BusinessData instance,
) => <String, dynamic>{
  'ownerFirstName': instance.ownerFirstName,
  'ownerLastName': instance.ownerLastName,
  'openDays': instance.openDays,
  'opensAt': instance.opensAt,
  'closesAt': instance.closesAt,
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'city': instance.city,
  'region': instance.region,
  'postalCode': instance.postalCode,
  'countryCode': instance.countryCode,
  'subtenant': instance.subtenant,
  'yearsAtLocation': instance.yearsAtLocation,
  'monthsAtLocation': instance.monthsAtLocation,
  'businessProperty': _$PropertyStatusEnumMap[instance.businessProperty],
  'residentialProperty': _$PropertyStatusEnumMap[instance.residentialProperty],
  'yearsAtResidence': instance.yearsAtResidence,
  'monthsAtResidence': instance.monthsAtResidence,
  'businessLandlordName': instance.businessLandlordName,
  'businessLandlordPhoneCountry': instance.businessLandlordPhoneCountry,
  'businessLandlordPhoneNumber': instance.businessLandlordPhoneNumber,
  'residentialLandlordName': instance.residentialLandlordName,
  'residentialLandlordPhoneCountry': instance.residentialLandlordPhoneCountry,
  'residentialLandlordPhoneNumber': instance.residentialLandlordPhoneNumber,
  'bankName': instance.bankName,
  'taxDesignation': _$TaxDesignationEnumMap[instance.taxDesignation],
  'taxId': instance.taxId,
};

const _$PropertyStatusEnumMap = {
  PropertyStatus.lease: 'lease',
  PropertyStatus.own: 'own',
};

const _$TaxDesignationEnumMap = {
  TaxDesignation.llcSoleEin: 'llcSoleEin',
  TaxDesignation.llcSoleSsn: 'llcSoleSsn',
  TaxDesignation.llcCCorp: 'llcCCorp',
  TaxDesignation.llcSCorp: 'llcSCorp',
};
