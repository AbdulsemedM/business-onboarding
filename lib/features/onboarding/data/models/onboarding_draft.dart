import 'package:freezed_annotation/freezed_annotation.dart';

import '../../step1_business/data/step1_business_data.dart';
import '../../step2_documents/data/step2_documents_data.dart';
import '../../step3_compliance/data/step3_compliance_data.dart';
import 'onboarding_step.dart';

part 'onboarding_draft.freezed.dart';
part 'onboarding_draft.g.dart';

/// Everything the user has entered so far. Saved locally so they can resume.
///
/// Each step adds its own data field here as it is built.
@freezed
abstract class OnboardingDraft with _$OnboardingDraft {
  const factory OnboardingDraft({
    @Default(OnboardingDraft.currentSchemaVersion) int schemaVersion,
    @Default(OnboardingStep.business) OnboardingStep currentStep,
    @Default(Step1BusinessData()) Step1BusinessData business,
    @Default(Step2DocumentsData()) Step2DocumentsData documents,
    @Default(Step3ComplianceData()) Step3ComplianceData compliance,
  }) = _OnboardingDraft;

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDraftFromJson(json);

  /// Bump when the saved shape changes in a way old drafts can't be read.
  static const currentSchemaVersion = 1;
}
