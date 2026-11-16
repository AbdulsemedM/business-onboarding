// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingDraft _$OnboardingDraftFromJson(
  Map<String, dynamic> json,
) => _OnboardingDraft(
  schemaVersion:
      (json['schemaVersion'] as num?)?.toInt() ??
      OnboardingDraft.currentSchemaVersion,
  currentStep:
      $enumDecodeNullable(_$OnboardingStepEnumMap, json['currentStep']) ??
      OnboardingStep.business,
  business: json['business'] == null
      ? const Step1BusinessData()
      : Step1BusinessData.fromJson(json['business'] as Map<String, dynamic>),
  documents: json['documents'] == null
      ? const Step2DocumentsData()
      : Step2DocumentsData.fromJson(json['documents'] as Map<String, dynamic>),
  compliance: json['compliance'] == null
      ? const Step3ComplianceData()
      : Step3ComplianceData.fromJson(
          json['compliance'] as Map<String, dynamic>,
        ),
  submitted: json['submitted'] as bool? ?? false,
  primaryOwnerId: json['primaryOwnerId'] as String?,
  applicationId: json['applicationId'] as String?,
);

Map<String, dynamic> _$OnboardingDraftToJson(_OnboardingDraft instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'currentStep': _$OnboardingStepEnumMap[instance.currentStep]!,
      'business': instance.business.toJson(),
      'documents': instance.documents.toJson(),
      'compliance': instance.compliance.toJson(),
      'submitted': instance.submitted,
      'primaryOwnerId': instance.primaryOwnerId,
      'applicationId': instance.applicationId,
    };

const _$OnboardingStepEnumMap = {
  OnboardingStep.business: 'business',
  OnboardingStep.documents: 'documents',
  OnboardingStep.compliance: 'compliance',
  OnboardingStep.review: 'review',
};
