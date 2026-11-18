import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/core/router/routes.dart'
    show OnboardingStepRoute;
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';
import 'package:business_onboarding/features/onboarding/step1_business/ui/step1_business_screen.dart';
import 'package:business_onboarding/features/onboarding/step2_documents/ui/step2_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_draft_store.dart';
import '../../../helpers/sample_data.dart';

void main() {
  late FakeDraftStore store;

  /// Opens the app directly on Step 1 with a tall screen so the whole form
  /// is built (ListView only builds what is visible).
  Future<void> openStep1(WidgetTester tester, [Step1BusinessData? data]) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    store = FakeDraftStore(
      data == null ? null : OnboardingDraft(business: data),
    );
    await tester.pumpWidget(
      App(draftStore: store, initialLocation: OnboardingStep.business.path),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextField, label);

  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }

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

  testWidgets('Next is blocked and errors shown when the form is empty', (
    tester,
  ) async {
    await openStep1(tester);

    await tapNext(tester);

    expect(find.text('Business details'), findsOneWidget);
    expect(find.text('Please fix the highlighted fields.'), findsOneWidget);
    expect(find.text('Select at least one day'), findsOneWidget);
    expect(find.text('This field is required'), findsWidgets);
    expect(store.stored?.currentStep, isNot(OnboardingStep.documents));
  });

  testWidgets('no errors while typing until Next is pressed', (tester) async {
    await openStep1(tester);

    await tester.enterText(field('Owner first name'), 'Alex');
    await tester.pump();
    expect(find.text('Select at least one day'), findsNothing);
    expect(find.text('This field is required'), findsNothing);

    await tapNext(tester);
    expect(find.text('Select at least one day'), findsOneWidget);

    // After Next, a fixed field clears its error as the user types.
    await tester.enterText(field('Owner last name'), 'Owner');
    await tester.pump();
    expect(
      find.descendant(
        of: find.ancestor(
          of: find.text('Owner last name'),
          matching: find.byType(TextField),
        ),
        matching: find.text('This field is required'),
      ),
      findsNothing,
    );
  });

  testWidgets('complete form moves on to Documents', (tester) async {
    await openStep1(tester, completeStep1);

    await tapNext(tester);

    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.currentStep, OnboardingStep.documents);
    expect(store.stored?.business, completeStep1);
  });

  testWidgets('saved answers are shown when the user comes back', (
    tester,
  ) async {
    await openStep1(tester, completeStep1);

    expect(find.text('Test Bank'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('9:00 AM'), findsOneWidget);
    expect(find.text('5:00 PM'), findsOneWidget);
  });

  testWidgets('typing updates the draft', (tester) async {
    await openStep1(tester);

    await tester.enterText(field('Personal bank name'), 'First Bank');
    await tester.enterText(field('Years').first, '12');
    await tester.pump(const Duration(seconds: 1)); // autosave delay

    expect(store.stored?.business.bankName, 'First Bank');
    expect(store.stored?.business.yearsAtLocation, 12);
  });

  testWidgets(
    'business landlord fields appear only when the business is leased',
    (tester) async {
      await openStep1(tester, completeStep1);
      expect(field('Business landlord name'), findsNothing);

      await selectDropdown(tester, Step1Fields.businessProperty, 'Lease');
      expect(field('Business landlord name'), findsOneWidget);
      expect(field('Business landlord phone'), findsOneWidget);

      // Leased without landlord details: blocked.
      await tapNext(tester);
      expect(find.text('Business details'), findsOneWidget);

      await tester.enterText(field('Business landlord name'), 'Pat Landlord');
      await tester.enterText(field('Business landlord phone'), '123');
      await tester.pump();
      await tapNext(tester);
      expect(
        find.text('Enter a valid phone number for the selected country'),
        findsOneWidget,
      );

      await tester.enterText(field('Business landlord phone'), validUsPhone);
      await tapNext(tester);
      expect(find.text('Documents'), findsOneWidget);
      expect(store.stored?.business.businessLandlordName, 'Pat Landlord');
      expect(store.stored?.business.businessLandlordPhoneNumber, validUsPhone);
      expect(store.stored?.business.businessLandlordPhoneCountry, 'US');
    },
  );

  testWidgets('switching back to Own hides and skips landlord fields', (
    tester,
  ) async {
    await openStep1(
      tester,
      completeStep1.copyWith(businessProperty: PropertyStatus.lease),
    );
    expect(field('Business landlord name'), findsOneWidget);

    await selectDropdown(tester, Step1Fields.businessProperty, 'Own');
    expect(field('Business landlord name'), findsNothing);

    await tapNext(tester);
    expect(find.text('Documents'), findsOneWidget);
  });

  testWidgets('rejects out-of-range months and identical open/close times', (
    tester,
  ) async {
    await openStep1(
      tester,
      completeStep1.copyWith(closesAt: completeStep1.opensAt),
    );

    await tester.enterText(field('Months').first, '12');
    await tapNext(tester);

    expect(find.text('Enter a number from 0 to 11'), findsOneWidget);
    expect(
      find.text('Closing time must be different from opening time'),
      findsOneWidget,
    );
    expect(find.text('Business details'), findsOneWidget);
  });

  testWidgets('tax options show their explanations', (tester) async {
    await openStep1(tester);

    final dropdown = find.byWidgetPredicate(
      (w) => w is FormBuilderDropdown && w.name == Step1Fields.taxDesignation,
    );
    await tester.ensureVisible(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    // The open menu explains each option.
    expect(find.text('Taxed as an S-Corporation (IRS Form 2553).'), findsOne);
    await tester.tap(find.text('LLC (C-Corporation Election)').last);
    await tester.pumpAndSettle();
    // The chosen option's explanation stays under the field.
    expect(find.text('Taxed as a C-Corporation (IRS Form 8832).'), findsOne);
    await tester.pump(const Duration(seconds: 1));

    expect(store.stored?.business.taxDesignation, TaxDesignation.llcCCorp);
  });

  testWidgets('country picker changes the phone country', (tester) async {
    await openStep1(
      tester,
      completeStep1.copyWith(businessProperty: PropertyStatus.lease),
    );

    await tester.tap(find.textContaining('+1'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'GB');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'GB'));
    await tester.pumpAndSettle();

    expect(find.textContaining('+44'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(store.stored?.business.businessLandlordPhoneCountry, 'GB');
  });

  testWidgets('fields below the fold are validated on a phone screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    store = FakeDraftStore(
      OnboardingDraft(business: completeStep1.copyWith(taxDesignation: null)),
    );
    await tester.pumpWidget(
      App(draftStore: store, initialLocation: OnboardingStep.business.path),
    );
    await tester.pumpAndSettle();

    await tapNext(tester);

    expect(find.text('Business details'), findsOneWidget);
    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('home landlord is required only when the home is leased', (
    tester,
  ) async {
    await openStep1(tester, completeStep1);
    expect(field('Home landlord name'), findsNothing);

    await selectDropdown(tester, Step1Fields.residentialProperty, 'Lease');
    expect(field('Home landlord name'), findsOneWidget);
    expect(field('Business landlord name'), findsNothing);

    await tapNext(tester);
    expect(find.text('Business details'), findsOneWidget);

    await tester.enterText(field('Home landlord name'), 'Robin Landlord');
    await tester.enterText(field('Home landlord phone'), validUsPhone);
    await tapNext(tester);
    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.business.residentialLandlordName, 'Robin Landlord');
    expect(store.stored?.business.residentialLandlordPhoneNumber, validUsPhone);
  });

  testWidgets('address line 1, city and owner name are required', (
    tester,
  ) async {
    await openStep1(
      tester,
      Step1BusinessData.fromJson(
        completeStep1.toJson()
          ..remove('addressLine1')
          ..remove('city')
          ..remove('ownerLastName'),
      ),
    );

    await tapNext(tester);
    expect(find.text('Business details'), findsOneWidget);
    expect(find.text('This field is required'), findsNWidgets(3));

    await tester.enterText(field('Street address'), ' 1 Main St ');
    await tester.enterText(field('City'), 'Dallas');
    await tester.enterText(field('Owner last name'), 'Owner');
    await tapNext(tester);

    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.business.addressLine1, '1 Main St');
    expect(store.stored?.business.city, 'Dallas');
    // Optional fields stay empty.
    expect(store.stored?.business.region, isNull);
    expect(store.stored?.business.postalCode, isNull);
    expect(store.stored?.business.yearsAtResidence, isNull);
  });

  testWidgets('time at residence is optional but range-checked', (
    tester,
  ) async {
    await openStep1(tester, completeStep1);

    final residenceMonths = find.byWidgetPredicate(
      (w) => w is FormBuilderTextField && w.name == Step1Fields.residenceMonths,
    );
    await tester.enterText(residenceMonths, '12');
    await tapNext(tester);
    expect(find.text('Enter a number from 0 to 11'), findsOneWidget);

    await tester.enterText(residenceMonths, '6');
    await tapNext(tester);
    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.business.monthsAtResidence, 6);
  });

  testWidgets('EIN is checked and saved as digits', (tester) async {
    await openStep1(tester, completeStep1.copyWith(taxId: null));
    final ein = field('Business EIN');
    expect(ein, findsOneWidget);
    expect(field("Owner's SSN"), findsNothing);

    await tester.enterText(ein, '12345');
    await tapNext(tester);
    expect(find.text('Enter a 9-digit EIN (XX-XXXXXXX)'), findsOneWidget);

    await tester.enterText(ein, '987654321');
    await tester.pump();
    expect(find.text('98-7654321'), findsOneWidget);
    await tapNext(tester);

    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.business.taxId, '987654321');
  });

  testWidgets('switching to the SSN designation asks for the SSN', (
    tester,
  ) async {
    await openStep1(tester, completeStep1);
    expect(find.text('12-3456789'), findsOneWidget);

    await selectDropdown(
      tester,
      Step1Fields.taxDesignation,
      'LLC (Sole Proprietorship / Single-Member LLC - SSN)',
    );

    expect(field('Business EIN'), findsNothing);
    expect(field("Owner's SSN"), findsOneWidget);
    expect(store.stored?.business.taxId, isNull);

    await tester.enterText(field("Owner's SSN"), '123456789');
    await tester.pump();
    expect(find.text('123-45-6789'), findsOneWidget);
    await tapNext(tester);
    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.business.taxDesignation, TaxDesignation.llcSoleSsn);
    expect(store.stored?.business.taxId, '123456789');
  });

  testWidgets('C-Corp and S-Corp keep the EIN', (tester) async {
    await openStep1(tester, completeStep1);

    await selectDropdown(
      tester,
      Step1Fields.taxDesignation,
      'LLC (S-Corporation Election)',
    );

    expect(find.text('12-3456789'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(store.stored?.business.taxId, '123456789');
  });

  testWidgets('sublease toggle adds the agreement card in Step 2', (
    tester,
  ) async {
    await openStep1(tester, completeStep1);

    await tester.tap(
      find.text('I sublease this location from another business'),
    );
    await tester.pumpAndSettle();
    await tapNext(tester);

    expect(find.text('Documents'), findsOneWidget);
    expect(store.stored?.business.subtenant, isTrue);
    expect(
      find.byKey(const ValueKey('document:${Step2Fields.subleaseAgreement}')),
      findsOneWidget,
    );
  });

  testWidgets('Back from Step 1 returns to Welcome', (tester) async {
    await openStep1(tester);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Start application'), findsOneWidget);
  });
}
