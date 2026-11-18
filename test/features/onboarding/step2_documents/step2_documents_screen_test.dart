import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/core/router/routes.dart'
    show OnboardingStepRoute;
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';
import 'package:business_onboarding/features/onboarding/step2_documents/data/step2_documents_data.dart';
import 'package:business_onboarding/features/onboarding/step2_documents/ui/step2_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/document_fakes.dart';
import '../../../helpers/fake_draft_store.dart';
import '../../../helpers/sample_data.dart';

const _required = 'Upload this document';
const _nextStepTitle = 'Operations and compliance';
const _firstPartner = Step2DocumentsData.firstPartnerId;

void main() {
  late FakeDraftStore store;
  late FakeDocumentRepository documents;

  /// Opens the app on Step 2. By default the screen is tall enough that
  /// every card is visible and can be tapped.
  Future<void> openStep2(
    WidgetTester tester, [
    Step2DocumentsData? data,
    Size size = const Size(1080, 9000),
    Step1BusinessData business = completeStep1,
  ]) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    store = FakeDraftStore(
      OnboardingDraft(
        currentStep: OnboardingStep.documents,
        business: business,
        documents: data ?? const Step2DocumentsData(),
      ),
    );
    await tester.pumpWidget(
      App(
        draftStore: store,
        initialLocation: OnboardingStep.documents.path,
        documentRepository: documents = FakeDocumentRepository(),
        documentPicker: FakeDocumentPicker(),
        filePreparer: FakeFilePreparer(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder card(String fieldName) => find.byKey(ValueKey('document:$fieldName'));

  Future<void> selectDropdown(
    WidgetTester tester,
    String fieldName,
    String option,
  ) async {
    final dropdown = find.byWidgetPredicate(
      (w) => w is FormBuilderDropdown && w.name == fieldName,
    );
    await tester.ensureVisible(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }

  Future<void> upload(WidgetTester tester, String fieldName) async {
    await tester.tap(
      find.descendant(of: card(fieldName), matching: find.text('Add document')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a file (PDF, JPG or PNG)'));
    await tester.pumpAndSettle();
  }

  Future<void> waitForAutosave(WidgetTester tester) =>
      tester.pump(const Duration(seconds: 1));

  testWidgets('empty step blocks Next and marks what is missing', (
    tester,
  ) async {
    await openStep2(tester);

    await tapNext(tester);

    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('Please fix the highlighted fields.'), findsOneWidget);
    // Business bill and three photos.
    expect(find.text(_required), findsNWidgets(4));
    // ID type, registration type, IRS type, license category, bill date.
    expect(find.text('This field is required'), findsNWidgets(5));
    // Optional cards, and cards that wait for a document type.
    expect(card(Step2Fields.additionalPhoto), findsOneWidget);
    expect(card(Step2Fields.idDocument(_firstPartner)), findsNothing);
    expect(card(Step2Fields.businessRegistration), findsNothing);
    expect(card(Step2Fields.irsRegistration), findsNothing);
    expect(card(Step2Fields.license), findsNothing);
    expect(card(Step2Fields.dbaDocument), findsNothing);
    expect(card(Step2Fields.subleaseAgreement), findsNothing);
  });

  testWidgets('complete step moves on to Step 3', (tester) async {
    await openStep2(tester, completeStep2());

    await tapNext(tester);

    expect(find.text(_nextStepTitle), findsOneWidget);
    expect(store.stored?.currentStep, OnboardingStep.compliance);
  });

  testWidgets('fields below the fold are validated on a phone screen', (
    tester,
  ) async {
    await openStep2(
      tester,
      completeStep2().copyWith(checkoutPhoto: null),
      const Size(400, 800),
    );

    await tapNext(tester);

    expect(find.text(_nextStepTitle), findsNothing);
    expect(
      find.descendant(
        of: card(Step2Fields.checkoutPhoto),
        matching: find.text(_required),
      ),
      findsOneWidget,
    );
  });

  testWidgets('uploading a document saves it to the draft', (tester) async {
    await openStep2(
      tester,
      Step2DocumentsData(businessUtilityBillDate: daysAgo(5)),
    );

    await upload(tester, Step2Fields.businessBill);
    await waitForAutosave(tester);

    expect(
      find.descendant(
        of: card(Step2Fields.businessBill),
        matching: find.text('Uploaded'),
      ),
      findsOneWidget,
    );
    expect(store.stored?.documents.businessUtilityBill, isNotNull);
    // The backend gets the type code and the bill date with the upload.
    expect(documents.lastDocumentType, 'BUSINESS_UTILITY_BILL');
    expect(documents.lastOptions?.documentDate, daysAgo(5));
  });

  testWidgets('a bill asks for its date before uploading', (tester) async {
    await openStep2(tester);

    await upload(tester, Step2Fields.businessBill);

    expect(
      find.text('Enter the bill date below first, then tap Retry.'),
      findsOneWidget,
    );
    expect(documents.uploadCount, 0);
    expect(store.stored?.documents.businessUtilityBill, isNull);
  });

  testWidgets('an ID upload names its owner on the server', (tester) async {
    await openStep2(
      tester,
      completeStep2().withPartnerUpdated(
        _firstPartner,
        (p) => p.copyWith(idDocument: null, idShowsPoBox: true),
      ),
    );

    await upload(tester, Step2Fields.idDocument(_firstPartner));
    await waitForAutosave(tester);

    expect(documents.lastDocumentType, 'DRIVERS_LICENSE');
    // Partner 1 is the Step 1 owner, saved on the server on demand.
    expect(documents.lastOptions?.businessOwnerId, 'mock-owner-1');
    expect(documents.lastOptions?.identificationListsPoBox, isTrue);
    expect(store.stored?.primaryOwnerId, 'mock-owner-1');
  });

  testWidgets('a new partner needs a name before their ID uploads', (
    tester,
  ) async {
    await openStep2(
      tester,
      completeStep2()
          .withPartnerAdded('p2')
          .withPartnerUpdated(
            'p2',
            (p) => p.copyWith(idType: PersonalIdType.governmentId),
          ),
    );

    await upload(tester, Step2Fields.idDocument('p2'));
    expect(
      find.text(
        "Enter this partner's first and last name first, then tap Retry.",
      ),
      findsOneWidget,
    );
    expect(documents.uploadCount, 0);
  });

  group('home utility bill', () {
    testWidgets('is required for a passport', (tester) async {
      await openStep2(tester, completeStep2());
      expect(card(Step2Fields.homeBill(_firstPartner)), findsNothing);
      expect(find.text('This ID lists a P.O. Box address'), findsOneWidget);

      await selectDropdown(
        tester,
        Step2Fields.idType(_firstPartner),
        'Passport',
      );

      expect(card(Step2Fields.homeBill(_firstPartner)), findsOneWidget);
      // A passport needs the bill anyway, so the question is hidden.
      expect(find.text('This ID lists a P.O. Box address'), findsNothing);

      await tapNext(tester);
      expect(find.text(_nextStepTitle), findsNothing);

      // The date comes first: the backend checks it on upload.
      await upload(tester, Step2Fields.homeBill(_firstPartner));
      expect(
        find.text('Enter the bill date below first, then tap Retry.'),
        findsOneWidget,
      );
      expect(store.stored?.documents.partners.single.homeUtilityBill, isNull);

      // Still blocked: no bill, no date.
      await tapNext(tester);
      expect(find.text(_nextStepTitle), findsNothing);
      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('is required when the ID lists a P.O. Box', (tester) async {
      await openStep2(tester, completeStep2());

      await tester.tap(find.text('This ID lists a P.O. Box address'));
      await tester.pumpAndSettle();
      expect(card(Step2Fields.homeBill(_firstPartner)), findsOneWidget);

      await tester.tap(find.text('This ID lists a P.O. Box address'));
      await tester.pumpAndSettle();
      expect(card(Step2Fields.homeBill(_firstPartner)), findsNothing);
      await tapNext(tester);
      expect(find.text(_nextStepTitle), findsOneWidget);
    });

    testWidgets('older than 60 days is rejected', (tester) async {
      final data = completeStep2();
      await openStep2(
        tester,
        data.withPartnerUpdated(
          _firstPartner,
          (p) => p.copyWith(
            idType: PersonalIdType.passport,
            homeUtilityBill: uploaded('home-bill'),
            homeUtilityBillDate: daysAgo(61),
          ),
        ),
      );

      await tapNext(tester);

      expect(
        find.text('The bill must be dated within the last 60 days'),
        findsOneWidget,
      );
      expect(find.text(_nextStepTitle), findsNothing);
    });
  });

  testWidgets('business bill older than 90 days is rejected, and the '
      'picker still opens on the old date', (tester) async {
    await openStep2(
      tester,
      completeStep2().copyWith(businessUtilityBillDate: daysAgo(91)),
    );

    await tapNext(tester);
    expect(
      find.text('The bill must be dated within the last 90 days'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(TextField, 'Bill date'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('license: category, then type, then the card', (tester) async {
    await openStep2(
      tester,
      completeStep2().copyWith(
        licenseCategory: null,
        licenseType: null,
        license: null,
      ),
    );
    expect(card(Step2Fields.license), findsNothing);

    await selectDropdown(tester, Step2Fields.licenseCategory, 'Transportation');
    // The chosen category's explanation shows under the field.
    expect(
      find.text(
        'DOT registration, commercial auto insurance, '
        'commercial vehicle registration.',
      ),
      findsOneWidget,
    );
    expect(find.text('License or permit type'), findsOneWidget);
    expect(card(Step2Fields.license), findsNothing);

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is FormBuilderDropdown && w.name == Step2Fields.licenseType,
      ),
    );
    await tester.pumpAndSettle();
    // Only the transportation types are offered.
    expect(find.text('Food license'), findsNothing);
    await tester.tap(find.text('DOT registration').last);
    await tester.pumpAndSettle();
    await waitForAutosave(tester);

    expect(card(Step2Fields.license), findsOneWidget);
    expect(store.stored?.documents.licenseType, LicenseType.dotRegistration);
    expect(LicenseType.dotRegistration.apiCode, 'DOT_REGISTRATION');
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);

    // Another category clears the type, so it must be picked again.
    await selectDropdown(
      tester,
      Step2Fields.licenseCategory,
      'Industry-specific permit',
    );
    await waitForAutosave(tester);
    expect(store.stored?.documents.licenseCategory, LicenseCategory.industry);
    expect(store.stored?.documents.licenseType, isNull);
    expect(card(Step2Fields.license), findsNothing);
  });

  testWidgets('registration and IRS cards follow the chosen type', (
    tester,
  ) async {
    await openStep2(
      tester,
      completeStep2().copyWith(registrationType: null, irsType: null),
    );
    expect(card(Step2Fields.businessRegistration), findsNothing);
    expect(card(Step2Fields.irsRegistration), findsNothing);

    await selectDropdown(
      tester,
      Step2Fields.registrationType,
      'Articles of Incorporation (corporation)',
    );
    await selectDropdown(tester, Step2Fields.irsType, 'Recent tax return');
    await waitForAutosave(tester);

    expect(card(Step2Fields.businessRegistration), findsOneWidget);
    expect(card(Step2Fields.irsRegistration), findsOneWidget);
    // The file uploaded earlier is kept.
    expect(store.stored?.documents.businessRegistration, isNotNull);
    expect(
      store.stored?.documents.registrationType,
      RegistrationDocType.articlesOfIncorporation,
    );
    expect(store.stored?.documents.irsType, IrsDocType.recentTaxReturn);
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
  });

  testWidgets('a subtenant (from Step 1) must upload the agreement', (
    tester,
  ) async {
    await openStep2(
      tester,
      completeStep2(),
      const Size(1080, 9000),
      completeStep1.copyWith(subtenant: true),
    );
    expect(card(Step2Fields.subleaseAgreement), findsOneWidget);

    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);

    await upload(tester, Step2Fields.subleaseAgreement);
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
    expect(store.stored?.documents.subleaseAgreement, isNotNull);
  });

  testWidgets('DBA toggle explains that photos are used', (tester) async {
    await openStep2(tester, completeStep2());
    const note =
        'We verify your trade name from your business photos. '
        'Make sure it is clearly visible in the exterior photo.';
    expect(find.text(note), findsNothing);

    await tester.tap(find.text('My business uses a trade name (DBA)'));
    await tester.pumpAndSettle();

    expect(find.text(note), findsOneWidget);
    // DBA documentation is optional.
    expect(card(Step2Fields.dbaDocument), findsOneWidget);

    // The trade name itself is required.
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);
    await tester.enterText(
      find.widgetWithText(TextField, 'Trade name (DBA)'),
      '  Corner Market  ',
    );
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
    expect(store.stored?.documents.usesTradeName, isTrue);
    expect(store.stored?.documents.tradeName, 'Corner Market');
  });

  testWidgets('partners can be added and removed', (tester) async {
    await openStep2(tester, completeStep2());
    expect(find.byTooltip('Remove partner 1'), findsNothing);

    await tester.tap(find.text('Add partner'));
    await tester.pumpAndSettle();
    expect(find.text('Partner 1 (owner)'), findsOneWidget);
    expect(find.text('Partner 2'), findsOneWidget);
    // Partner 1 is the owner from Step 1, so only partner 2 has name fields.
    expect(
      find.widgetWithText(TextField, 'First name (as on ID)'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextField, 'Last name (as on ID)'),
      findsOneWidget,
    );

    // The new partner's name and ID are required.
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);

    // Cancelling keeps the partner.
    await tester.tap(find.byTooltip('Remove partner 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Partner 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove partner 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();
    expect(find.text('Partner 2'), findsNothing);

    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
    expect(store.stored?.documents.partners, hasLength(1));
  });

  testWidgets('partner 1 shows the owner from Step 1', (tester) async {
    await openStep2(tester, completeStep2());
    expect(find.text('Alex Owner, from business details'), findsOneWidget);
  });

  testWidgets('partner names are required and saved trimmed', (tester) async {
    await openStep2(
      tester,
      completeStep2()
          .withPartnerAdded('p2')
          .withPartnerUpdated(
            'p2',
            (p) => p.copyWith(
              idType: PersonalIdType.governmentId,
              idDocument: uploaded('id2'),
            ),
          ),
    );

    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsNothing);
    expect(find.text('This field is required'), findsNWidgets(2));

    await tester.enterText(
      find.widgetWithText(TextField, 'First name (as on ID)'),
      ' Jo ',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Last name (as on ID)'),
      ' Partner ',
    );
    await tapNext(tester);
    expect(find.text(_nextStepTitle), findsOneWidget);
    expect(store.stored?.documents.partners.last.firstName, 'Jo');
    expect(store.stored?.documents.partners.last.lastName, 'Partner');
  });

  testWidgets('the ID card appears once the ID type is chosen', (tester) async {
    await openStep2(tester, completeStep2().withPartnerAdded('p2'));
    expect(card(Step2Fields.idDocument('p2')), findsNothing);

    await selectDropdown(tester, Step2Fields.idType('p2'), 'Passport');

    expect(card(Step2Fields.idDocument('p2')), findsOneWidget);
    expect(find.text('Partner 2: photo ID'), findsOneWidget);
  });

  testWidgets('meets tap target and label guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await openStep2(tester, completeStep2().withPartnerAdded('p2'));

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('layout survives 2x text size on a phone', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openStep2(tester, completeStep2(), const Size(400, 800));

    expect(tester.takeException(), isNull);
  });

  testWidgets('each partner keeps its own upload after one is removed', (
    tester,
  ) async {
    await openStep2(
      tester,
      completeStep2()
          .withPartnerAdded('p2')
          .withPartnerAdded('p3')
          .withPartnerUpdated(
            'p3',
            (p) => p.copyWith(
              idType: PersonalIdType.driversLicense,
              firstName: 'Jo',
              lastName: 'Partner',
            ),
          ),
    );

    await upload(tester, Step2Fields.idDocument('p3'));
    await tester.tap(find.byTooltip('Remove partner 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();
    await waitForAutosave(tester);

    // The former partner 3 is now partner 2 and still has its upload.
    expect(find.text('Partner 2: photo ID'), findsOneWidget);
    expect(
      find.descendant(
        of: card(Step2Fields.idDocument('p3')),
        matching: find.text('Uploaded'),
      ),
      findsOneWidget,
    );
    expect(store.stored?.documents.partners.map((p) => p.id), [
      _firstPartner,
      'p3',
    ]);
    expect(store.stored?.documents.partners.last.idDocument, isNotNull);
  });
}
