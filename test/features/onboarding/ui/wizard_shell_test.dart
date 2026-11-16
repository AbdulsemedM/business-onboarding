import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:business_onboarding/features/onboarding/ui/widgets/step_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_draft_store.dart';
import '../../../helpers/sample_data.dart';

void main() {
  testWidgets('user can move through the steps and back', (tester) async {
    // Step 1 must be valid for Next to work.
    final store = FakeDraftStore(
      const OnboardingDraft(business: completeStep1),
    );
    await tester.pumpWidget(App(draftStore: store));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continue application'));
    await tester.tap(find.text('Continue application'));
    await tester.pumpAndSettle();
    expect(find.text('Business details'), findsOneWidget);
    expect(find.text('Step 1 of 4'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('Step 2 of 4'), findsOneWidget);
    expect(store.stored?.currentStep, OnboardingStep.documents);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Business details'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Continue application'), findsOneWidget);
  });

  testWidgets('returning user resumes at the saved step', (tester) async {
    final store = FakeDraftStore(
      const OnboardingDraft(currentStep: OnboardingStep.compliance),
    );
    await tester.pumpWidget(App(draftStore: store));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continue application'));
    await tester.tap(find.text('Continue application'));
    await tester.pumpAndSettle();
    expect(find.text('Operations and compliance'), findsOneWidget);
    expect(find.text('Step 3 of 4'), findsOneWidget);
  });

  testWidgets('last step shows Submit instead of Next', (tester) async {
    final store = FakeDraftStore(
      const OnboardingDraft(currentStep: OnboardingStep.review),
    );
    await tester.pumpWidget(App(draftStore: store));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue application'));
    await tester.tap(find.text('Continue application'));
    await tester.pumpAndSettle();

    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('progress is announced to screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(App(draftStore: FakeDraftStore()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Start application'));
    await tester.tap(find.text('Start application'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byType(StepProgressIndicator)),
      containsSemantics(label: 'Step 1 of 4: Business details'),
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('layout survives 2x text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(App(draftStore: FakeDraftStore()));
    await tester.pumpAndSettle();
    final start = find.text('Start application');
    await tester.scrollUntilVisible(start, 100);
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
