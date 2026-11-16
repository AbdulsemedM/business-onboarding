import 'package:bloc_test/bloc_test.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:business_onboarding/features/onboarding/logic/wizard_cubit.dart';
import 'package:business_onboarding/features/onboarding/logic/wizard_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_draft_store.dart';

void main() {
  const autosaveDelay = Duration(milliseconds: 20);
  late FakeDraftStore store;

  setUp(() => store = FakeDraftStore());

  WizardCubit build() =>
      WizardCubit(draftStore: store, autosaveDelay: autosaveDelay);

  group('load', () {
    blocTest<WizardCubit, WizardState>(
      'starts a new draft when nothing is saved',
      build: build,
      act: (cubit) => cubit.load(),
      expect: () => [const WizardState(isLoaded: true)],
    );

    blocTest<WizardCubit, WizardState>(
      'restores a saved draft',
      setUp: () => store.stored = const OnboardingDraft(
        currentStep: OnboardingStep.documents,
      ),
      build: build,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.isLoaded, isTrue);
        expect(cubit.state.hasSavedDraft, isTrue);
        expect(cubit.state.step, OnboardingStep.documents);
      },
    );
  });

  group('goTo', () {
    blocTest<WizardCubit, WizardState>(
      'changes step and saves immediately',
      build: build,
      act: (cubit) => cubit.goTo(OnboardingStep.compliance),
      verify: (cubit) {
        expect(cubit.state.step, OnboardingStep.compliance);
        expect(store.saveCount, 1);
        expect(store.stored?.currentStep, OnboardingStep.compliance);
      },
    );

    blocTest<WizardCubit, WizardState>(
      'does nothing for the current step',
      build: build,
      act: (cubit) => cubit.goTo(OnboardingStep.business),
      expect: () => <WizardState>[],
      verify: (_) => expect(store.saveCount, 0),
    );
  });

  group('updateDraft', () {
    blocTest<WizardCubit, WizardState>(
      'saves once after rapid changes',
      build: build,
      act: (cubit) async {
        for (final step in OnboardingStep.values) {
          cubit.updateDraft((d) => d.copyWith(currentStep: step));
        }
        expect(store.saveCount, 0);
        await Future<void>.delayed(autosaveDelay * 3);
      },
      verify: (_) {
        expect(store.saveCount, 1);
        expect(store.stored?.currentStep, OnboardingStep.review);
      },
    );

    test('close saves a pending change', () async {
      final cubit = build()
        ..updateDraft((d) => d.copyWith(currentStep: OnboardingStep.review));
      await cubit.close();
      expect(store.saveCount, 1);
      expect(store.stored?.currentStep, OnboardingStep.review);
    });
  });

  blocTest<WizardCubit, WizardState>(
    'discardDraft clears the store and resets state',
    setUp: () => store.stored = const OnboardingDraft(
      currentStep: OnboardingStep.review,
    ),
    build: build,
    act: (cubit) async {
      await cubit.load();
      await cubit.discardDraft();
    },
    skip: 1,
    expect: () => [const WizardState(isLoaded: true)],
    verify: (_) => expect(store.stored, isNull),
  );
}
