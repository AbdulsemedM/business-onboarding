// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step3_compliance_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionProcessor _$TransactionProcessorFromJson(
  Map<String, dynamic> json,
) => _TransactionProcessor(
  id: json['id'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
);

Map<String, dynamic> _$TransactionProcessorToJson(
  _TransactionProcessor instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
};

_Step3ComplianceData _$Step3ComplianceDataFromJson(
  Map<String, dynamic> json,
) => _Step3ComplianceData(
  processors:
      (json['processors'] as List<dynamic>?)
          ?.map((e) => TransactionProcessor.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [TransactionProcessor(id: Step3ComplianceData.firstProcessorId)],
  complianceOfficerIsOwner: json['complianceOfficerIsOwner'] as bool? ?? true,
  complianceOfficerFirstName: json['complianceOfficerFirstName'] as String?,
  complianceOfficerLastName: json['complianceOfficerLastName'] as String?,
);

Map<String, dynamic> _$Step3ComplianceDataToJson(
  _Step3ComplianceData instance,
) => <String, dynamic>{
  'processors': instance.processors.map((e) => e.toJson()).toList(),
  'complianceOfficerIsOwner': instance.complianceOfficerIsOwner,
  'complianceOfficerFirstName': instance.complianceOfficerFirstName,
  'complianceOfficerLastName': instance.complianceOfficerLastName,
};
