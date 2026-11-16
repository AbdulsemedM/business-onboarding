import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/onboarding_draft.dart';
import '../data/models/onboarding_step.dart';

part 'wizard_state.freezed.dart';

@freezed
abstract class WizardState with _$WizardState {
  const factory WizardState({
    @Default(OnboardingDraft()) OnboardingDraft draft,

    /// True once the saved draft (if any) has been read from the device.
    @Default(false) bool isLoaded,

    /// True if a saved draft was found on startup.
    @Default(false) bool hasSavedDraft,
  }) = _WizardState;

  const WizardState._();

  OnboardingStep get step => draft.currentStep;
}
