import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/core/router/routes.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/application_fakes.dart';
import '../../helpers/document_fakes.dart';
import '../../helpers/fake_draft_store.dart';
import '../../helpers/sample_data.dart';

void main() {
  late FakeDraftStore store;
  late FakeApplicationRepository repository;

  final completeDraft = OnboardingDraft(
    currentStep: OnboardingStep.review,
    business: completeStep1,
    documents: completeStep2(),
    compliance: completeStep3,
  );

  Future<void> open(
    WidgetTester tester, {
    required String location,
    OnboardingDraft? draft,
    ApplicationSnapshot snapshot = actionRequired,
  }) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    store = FakeDraftStore(draft ?? completeDraft);
    repository = FakeApplicationRepository(snapshot);
    await tester.pumpWidget(
      App(
        draftStore: store,
        initialLocation: location,
        applicationRepository: repository,
        documentRepository: FakeDocumentRepository(),
        documentPicker: FakeDocumentPicker(),
        filePreparer: FakeFilePreparer(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Review', () {
    testWidgets('summarizes every step and masks the tax ID', (tester) async {
      await open(tester, location: OnboardingStep.review.path);

      expect(find.text('Business details'), findsOneWidget);
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Operations and compliance'), findsOneWidget);
      expect(find.text('Alex Owner'), findsOneWidget);
      expect(find.text('100 Market St\nAustin\nUS'), findsOneWidget);
      expect(find.text('•••••6789'), findsOneWidget);
      expect(find.textContaining('123456789'), findsNothing);
      expect(find.text('Alex Owner: Driver\'s license'), findsOneWidget);
      expect(find.text('Sam Cashier'), findsOneWidget);
      expect(find.text('Alex Owner (owner)'), findsOneWidget);
      expect(find.text('Missing'), findsNothing);
    });

    testWidgets('marks what is missing', (tester) async {
      await open(
        tester,
        location: OnboardingStep.review.path,
        draft: completeDraft.copyWith(
          business: completeStep1.copyWith(bankName: null),
        ),
      );
      expect(find.text('Missing'), findsOneWidget);
    });

    testWidgets('Edit opens that step', (tester) async {
      await open(tester, location: OnboardingStep.review.path);

      await tester.tap(find.bySemanticsLabel('Edit Documents'));
      await tester.pumpAndSettle();

      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(store.stored?.currentStep, OnboardingStep.documents);
    });

    testWidgets('Submit asks first, then shows the status', (tester) async {
      await open(tester, location: OnboardingStep.review.path);

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('Submit your application?'), findsOneWidget);

      // Cancel sends nothing.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repository.submitCount, 0);

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Submit').last);
      await tester.pumpAndSettle();

      expect(repository.submitCount, 1);
      expect(find.text('Application status'), findsOneWidget);
      expect(find.text('A few things need your attention'), findsOneWidget);
      expect(store.stored?.submitted, isTrue);
    });

    testWidgets('a failed submit explains why and stays on Review', (
      tester,
    ) async {
      await open(tester, location: OnboardingStep.review.path);
      repository.failure = const AppFailure.network();

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Submit').last);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No internet connection. Check your connection and try '
          'again.',
        ),
        findsOneWidget,
      );
      expect(find.text('Step 4 of 4'), findsOneWidget);
      expect(store.stored?.submitted, isFalse);
    });
  });

  group('Status', () {
    testWidgets('only rejected documents can be uploaded again, then '
        'resubmitted', (tester) async {
      await open(
        tester,
        location: Routes.status,
        draft: completeDraft.copyWith(submitted: true),
      );
      repository.afterResubmit = inReview;

      expect(find.text('Action needed'), findsOneWidget);
      expect(find.text('Exterior photo'), findsOneWidget);
      expect(find.text('Reason: Business name not visible'), findsOneWidget);
      // Nothing else from Step 2 is offered.
      expect(find.text('Business utility bill'), findsNothing);

      final resubmit = find.widgetWithText(FilledButton, 'Resubmit for review');
      expect(tester.widget<FilledButton>(resubmit).onPressed, isNull);

      await tester.tap(find.text('Replace'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose a file (PDF, JPG or PNG)'));
      await tester.pumpAndSettle();

      expect(tester.widget<FilledButton>(resubmit).onPressed, isNotNull);
      await tester.tap(resubmit);
      await tester.pumpAndSettle();

      expect(repository.resubmittedIds, [photoCorrection.id]);
      expect(find.text('In review'), findsOneWidget);
      expect(find.text('Resubmit for review'), findsNothing);
    });

    testWidgets('a field to fix links back into the wizard', (tester) async {
      await open(
        tester,
        location: Routes.status,
        draft: completeDraft.copyWith(submitted: true),
        snapshot: const ApplicationSnapshot(
          status: ApplicationStatus.actionRequired,
          corrections: [
            CorrectionItem(
              id: 'c-bank',
              label: 'Personal bank name',
              reason: 'Use the full name',
              step: OnboardingStep.business,
            ),
          ],
        ),
      );

      expect(find.text('Resubmit for review'), findsNothing);
      await tester.tap(find.text('Fix in Business details'));
      await tester.pumpAndSettle();

      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(store.stored?.currentStep, OnboardingStep.business);
    });

    testWidgets('a load error can be retried', (tester) async {
      store = FakeDraftStore(completeDraft.copyWith(submitted: true));
      repository = FakeApplicationRepository(inReview)
        ..failure = const AppFailure.server();
      await tester.pumpWidget(
        App(
          draftStore: store,
          initialLocation: Routes.status,
          applicationRepository: repository,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Try again'), findsOneWidget);

      repository.failure = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('In review'), findsOneWidget);
    });

    testWidgets('Welcome sends a submitted agent to the status', (
      tester,
    ) async {
      await open(
        tester,
        location: Routes.welcome,
        draft: completeDraft.copyWith(submitted: true),
        snapshot: inReview,
      );

      await tester.tap(find.text('View application status'));
      await tester.pumpAndSettle();
      expect(find.text("We're reviewing your application"), findsOneWidget);
    });

    testWidgets('layout survives 2x text size', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        App(
          draftStore: FakeDraftStore(completeDraft.copyWith(submitted: true)),
          initialLocation: Routes.status,
          applicationRepository: FakeApplicationRepository(actionRequired),
          documentRepository: FakeDocumentRepository(),
          documentPicker: FakeDocumentPicker(),
          filePreparer: FakeFilePreparer(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
