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

  const appA = 'app-a';

  /// A cubit with application A open.
  Future<WizardCubit> opened() async {
    final cubit = build();
    await cubit.open(appA);
    store.saveCount = 0;
    return cubit;
  }

  group('open', () {
    blocTest<WizardCubit, WizardState>(
      'starts a new draft for the application when nothing is saved',
      build: build,
      act: (cubit) => cubit.open(appA),
      expect: () => [
        const WizardState(
          isLoaded: true,
          draft: OnboardingDraft(applicationId: appA),
        ),
      ],
    );

    blocTest<WizardCubit, WizardState>(
      'restores the saved draft of the application',
      setUp: () => store.drafts[appA] = const OnboardingDraft(
        applicationId: appA,
        currentStep: OnboardingStep.documents,
      ),
      build: build,
      act: (cubit) => cubit.open(appA),
      verify: (cubit) {
        expect(cubit.state.isLoaded, isTrue);
        expect(cubit.state.hasSavedDraft, isTrue);
        expect(cubit.state.step, OnboardingStep.documents);
      },
    );

    test('switching saves the open draft and loads the other', () async {
      store.drafts['app-b'] = const OnboardingDraft(
        applicationId: 'app-b',
        currentStep: OnboardingStep.review,
      );
      final cubit = await opened();
      cubit.updateDraft(
        (d) => d.copyWith(currentStep: OnboardingStep.compliance),
      );
      await cubit.open('app-b');
      expect(cubit.state.step, OnboardingStep.review);
      expect(store.drafts[appA]?.currentStep, OnboardingStep.compliance);
      await cubit.close();
    });

    test('nothing is saved before an application is open', () async {
      final cubit = build()
        ..updateDraft((d) => d.copyWith(currentStep: OnboardingStep.review));
      await cubit.close();
      expect(store.saveCount, 0);
    });
  });

  group('goTo', () {
    test('changes step and saves immediately', () async {
      final cubit = await opened();
      await cubit.goTo(OnboardingStep.compliance);
      expect(cubit.state.step, OnboardingStep.compliance);
      expect(store.saveCount, 1);
      expect(store.drafts[appA]?.currentStep, OnboardingStep.compliance);
      await cubit.close();
    });

    test('does nothing for the current step', () async {
      final cubit = await opened();
      await cubit.goTo(OnboardingStep.business);
      expect(store.saveCount, 0);
      await cubit.close();
    });
  });

  group('updateDraft', () {
    test('saves once after rapid changes', () async {
      final cubit = await opened();
      for (final step in OnboardingStep.values) {
        cubit.updateDraft((d) => d.copyWith(currentStep: step));
      }
      expect(store.saveCount, 0);
      await Future<void>.delayed(autosaveDelay * 3);
      expect(store.saveCount, 1);
      expect(store.drafts[appA]?.currentStep, OnboardingStep.review);
      await cubit.close();
    });

    test('close saves a pending change', () async {
      final cubit = await opened();
      cubit.updateDraft((d) => d.copyWith(currentStep: OnboardingStep.review));
      await cubit.close();
      expect(store.saveCount, 1);
      expect(store.drafts[appA]?.currentStep, OnboardingStep.review);
    });
  });

  test('discardDraft clears only the open application draft', () async {
    store.drafts['app-b'] = const OnboardingDraft(applicationId: 'app-b');
    store.drafts[appA] = const OnboardingDraft(
      applicationId: appA,
      currentStep: OnboardingStep.review,
    );
    final cubit = await opened();
    await cubit.discardDraft();
    expect(
      cubit.state,
      const WizardState(
        isLoaded: true,
        draft: OnboardingDraft(applicationId: appA),
      ),
    );
    expect(store.drafts.keys, ['app-b']);
    await cubit.close();
  });

  test('discardAllDrafts empties the store', () async {
    store.drafts['app-b'] = const OnboardingDraft(applicationId: 'app-b');
    final cubit = await opened();
    await cubit.discardAllDrafts();
    expect(store.drafts, isEmpty);
    expect(cubit.state.isLoaded, isFalse);
    await cubit.close();
  });

  test('retainDrafts keeps only the given applications', () async {
    store.drafts
      ..['app-a'] = const OnboardingDraft(applicationId: 'app-a')
      ..['other'] = const OnboardingDraft(applicationId: 'other');
    final cubit = build();
    await cubit.retainDrafts({'app-a'});
    expect(store.drafts.keys, ['app-a']);
    await cubit.close();
  });
}
