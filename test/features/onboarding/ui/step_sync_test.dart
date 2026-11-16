import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/core/router/routes.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/application_fakes.dart';
import '../../../helpers/document_fakes.dart';
import '../../../helpers/fake_draft_store.dart';
import '../../../helpers/sample_data.dart';

void main() {
  late FakeDraftStore store;
  late FakeApplicationRepository repository;

  Future<void> open(WidgetTester tester, OnboardingDraft draft) async {
    tester.view.physicalSize = const Size(1080, 9000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    store = FakeDraftStore(draft);
    repository = FakeApplicationRepository(inReview);
    await tester.pumpWidget(
      App(
        draftStore: store,
        initialLocation: draft.currentStep.path,
        applicationRepository: repository,
        documentRepository: FakeDocumentRepository(),
        documentPicker: FakeDocumentPicker(),
        filePreparer: FakeFilePreparer(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }

  testWidgets('Next saves Step 1 and keeps the owner id', (tester) async {
    await open(tester, const OnboardingDraft(business: completeStep1));

    await tapNext(tester);

    expect(repository.saves, ['business']);
    expect(find.text('Step 2 of 4'), findsOneWidget);
    expect(store.stored?.primaryOwnerId, 'owner-1');
  });

  testWidgets('a failed save stays on the step and keeps the answers', (
    tester,
  ) async {
    await open(tester, const OnboardingDraft(business: completeStep1));
    repository.failure = const AppFailure.network();

    await tapNext(tester);

    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(
      find.text('No internet connection. Check your connection and try again.'),
      findsOneWidget,
    );
    expect(store.stored?.business, completeStep1);
  });

  testWidgets("the server's reasons are listed", (tester) async {
    await open(tester, const OnboardingDraft(business: completeStep1));
    repository.failure = const AppFailure.validation(
      messages: ['Business location address city: must not be blank'],
    );

    await tapNext(tester);

    expect(find.text('A few things are still needed'), findsOneWidget);
    expect(
      find.text('• Business location address city: must not be blank'),
      findsOneWidget,
    );
  });

  testWidgets('Next on Documents saves added partners', (tester) async {
    await open(
      tester,
      OnboardingDraft(
        currentStep: OnboardingStep.documents,
        business: completeStep1,
        documents: completeStep2()
            .withPartnerAdded('p2')
            .withPartnerUpdated(
              'p2',
              (p) => p.copyWith(
                firstName: 'Jo',
                lastName: 'Partner',
                idType: completeStep2().owner.idType,
                idDocument: uploaded('id2'),
              ),
            ),
      ),
    );

    await tapNext(tester);

    expect(repository.saves, ['partner']);
    expect(store.stored?.documents.partners.last.ownerId, 'owner-2');
    expect(find.text('Step 3 of 4'), findsOneWidget);
  });

  testWidgets('Next on Step 3 saves the staff with the owner id', (
    tester,
  ) async {
    await open(
      tester,
      OnboardingDraft(
        currentStep: OnboardingStep.compliance,
        business: completeStep1,
        documents: completeStep2(),
        compliance: completeStep3,
        primaryOwnerId: 'owner-1',
      ),
    );

    await tapNext(tester);

    expect(repository.saves, ['compliance']);
    expect(repository.savedCompliance?.primaryOwnerId, 'owner-1');
    expect(find.text('Step 4 of 4'), findsOneWidget);
  });

  testWidgets('removing a saved partner deletes them on the server', (
    tester,
  ) async {
    await open(
      tester,
      OnboardingDraft(
        currentStep: OnboardingStep.documents,
        business: completeStep1,
        documents: completeStep2()
            .withPartnerAdded('p2')
            .withPartnerUpdated('p2', (p) => p.copyWith(ownerId: 'owner-9')),
      ),
    );

    await tester.tap(find.byTooltip('Remove partner 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(repository.removedPartners, ['owner-9']);
    expect(find.text('Partner 2'), findsNothing);
  });

}
