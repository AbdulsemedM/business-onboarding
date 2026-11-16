import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/core/router/routes.dart'
    show OnboardingStepRoute;
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';
import 'package:business_onboarding/features/onboarding/step3_compliance/data/step3_compliance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_draft_store.dart';
import '../../../helpers/sample_data.dart';

const _nextStepTitle = 'Review and submit';

void main() {
  late FakeDraftStore store;

  Future<void> openStep3(
    WidgetTester tester, {
    Step3ComplianceData compliance = const Step3ComplianceData(),
    Step1BusinessData business = completeStep1,
  }) async {
    // Tall enough that every field is on screen and can be tapped.
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    store = FakeDraftStore(
      OnboardingDraft(
        currentStep: OnboardingStep.compliance,
        business: business,
        documents: completeStep2(),
        compliance: compliance,
      ),
    );
    await tester.pumpWidget(
      App(draftStore: store, initialLocation: OnboardingStep.compliance.path),
    );
    await tester.pumpAndSettle();
  }

  // While the officer is the owner, only processors have these labels.
  Finder processorFirst(int number) =>
      find.widgetWithText(TextField, 'First name').at(number - 1);
  Finder processorLast(int number) =>
      find.widgetWithText(TextField, 'Last name').at(number - 1);

  List<String> storedProcessors() => [
    for (final p in store.stored!.compliance.processors)
      '${p.firstName} ${p.lastName}',
  ];

  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }

  Future<void> waitForAutosave(WidgetTester tester) =>
      tester.pump(const Duration(seconds: 1));

  testWidgets('empty step blocks Next', (tester) async {
    await openStep3(tester);

    await tapNext(tester);

    expect(find.text('Operations and compliance'), findsOneWidget);
    expect(find.text('This field is required'), findsNWidgets(2));
    expect(store.stored?.currentStep, OnboardingStep.compliance);
  });

  testWidgets('complete step moves on to Review', (tester) async {
    await openStep3(tester, compliance: completeStep3);

    await tapNext(tester);

    expect(find.text(_nextStepTitle), findsOneWidget);
    expect(store.stored?.currentStep, OnboardingStep.review);
  });

  testWidgets('processors can be added, typed and removed', (tester) async {
    await openStep3(tester, compliance: completeStep3);
    // The only processor can't be removed.
    expect(find.byTooltip('Remove processor 1'), findsNothing);

    await tester.tap(find.text('Add processor'));
    await tester.pumpAndSettle();
    expect(find.text('Processor 2'), findsOneWidget);
    // The new first-name field is focused, ready to type.
    expect(
      tester.widget<TextField>(processorFirst(2)).focusNode?.hasFocus,
      isTrue,
    );

    // An empty new processor blocks Next.
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);

    await tester.enterText(processorFirst(2), ' Jo ');
    await tester.enterText(processorLast(2), ' Clerk ');
    await waitForAutosave(tester);
    expect(storedProcessors(), ['Sam Cashier', 'Jo Clerk']);

    // Removing the first keeps the second's text in its own field.
    await tester.tap(find.byTooltip('Remove processor 1'));
    await tester.pumpAndSettle();
    await waitForAutosave(tester);
    expect(find.text('Sam'), findsNothing);
    expect(
      find.descendant(of: processorFirst(1), matching: find.text(' Jo ')),
      findsOneWidget,
    );
    expect(storedProcessors(), ['Jo Clerk']);
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
  });

  testWidgets('"Same as owner" names the owner from Step 1', (tester) async {
    await openStep3(tester, compliance: completeStep3);
    expect(find.text('Owner: Alex Owner'), findsOneWidget);
  });

  testWidgets('"Same as owner" explains who the owner is when unnamed', (
    tester,
  ) async {
    await openStep3(
      tester,
      compliance: completeStep3,
      business: const Step1BusinessData(),
    );
    expect(
      find.text('The owner you entered in Business details.'),
      findsOneWidget,
    );
  });

  testWidgets('another Compliance Officer needs a name', (tester) async {
    await openStep3(tester, compliance: completeStep3);
    final first = find.widgetWithText(
      TextField,
      'Compliance Officer first name',
    );
    final last = find.widgetWithText(TextField, 'Compliance Officer last name');
    expect(first, findsNothing);

    await tester.tap(find.text('Same as owner'));
    await tester.pumpAndSettle();
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);
    expect(find.text('This field is required'), findsNWidgets(2));

    await tester.enterText(first, 'Casey');
    await tester.enterText(last, 'Officer');
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
    final compliance = store.stored!.compliance;
    expect(compliance.complianceOfficerIsOwner, isFalse);
    expect(compliance.complianceOfficerFirstName, 'Casey');
    expect(compliance.complianceOfficerLastName, 'Officer');
  });

  testWidgets('meets tap target and label guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await openStep3(
      tester,
      compliance: completeStep3
          .withProcessorAdded('p2')
          .copyWith(complianceOfficerIsOwner: false),
    );

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('layout survives 2x text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openStep3(tester, compliance: completeStep3);

    expect(tester.takeException(), isNull);
  });
}
