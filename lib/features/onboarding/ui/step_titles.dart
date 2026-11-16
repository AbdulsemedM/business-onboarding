import '../../../l10n/app_localizations.dart';
import '../data/models/onboarding_step.dart';

extension OnboardingStepTitle on OnboardingStep {
  String title(AppLocalizations l10n) => switch (this) {
    OnboardingStep.business => l10n.stepBusinessTitle,
    OnboardingStep.documents => l10n.stepDocumentsTitle,
    OnboardingStep.compliance => l10n.stepComplianceTitle,
    OnboardingStep.review => l10n.stepReviewTitle,
  };
}
