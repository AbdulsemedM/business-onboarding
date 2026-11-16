import 'package:business_onboarding/features/onboarding/data/api_mappers.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';
import 'package:business_onboarding/features/onboarding/step3_compliance/data/step3_compliance_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/sample_data.dart';

void main() {
  group('businessDetailsBody', () {
    test('matches the backend Step 1 shape', () {
      final body = businessDetailsBody(
        completeStep1.copyWith(
          region: 'TX',
          businessProperty: PropertyStatus.lease,
          businessLandlordName: 'Pat Landlord',
          businessLandlordPhoneNumber: validUsPhone,
        ),
      );

      final intervals = (body['operatingHours'] as Map)['intervals'] as List;
      expect(intervals, hasLength(7));
      expect(intervals.first, {
        'dayOfWeek': 'MONDAY',
        'intervalIndex': 0,
        'opensAt': '09:00:00',
        'closesAt': '17:00:00',
        'closedAllDay': false,
      });
      // Closed days still carry the fields the backend requires.
      expect(intervals.last, {
        'dayOfWeek': 'SUNDAY',
        'intervalIndex': 0,
        'closedAllDay': true,
      });
      expect(body['monthsAtLocation'], 3 * 12 + 4);
      expect(body['propertyStatus'], {
        'businessLocationTenure': 'LEASED',
        'residentialHomeTenure': 'OWNED',
      });
      expect(body['businessLandlordDetails'], {
        'name': 'Pat Landlord',
        'phone': '+16502530000',
      });
      expect(body.containsKey('residentialLandlordDetails'), isFalse);
      expect(body['businessTaxDesignation'], {
        'taxClassificationCode': 'LLC_SINGLE_MEMBER_EIN',
        'identifierKind': 'EIN',
        'identifierValue': '123456789',
      });
      expect(body['businessLocationAddress'], {
        'subtenant': false,
        'line1': '100 Market St',
        'city': 'Austin',
        'region': 'TX',
        'countryCode': 'US',
      });
      expect(body['primaryOwner'], {
        'ownerType': 'INDIVIDUAL',
        'firstName': 'Alex',
        'lastName': 'Owner',
      });
    });

    test('hidden landlord answers are not sent', () {
      final body = businessDetailsBody(
        completeStep1.copyWith(businessLandlordName: 'Old answer'),
      );
      expect(body.containsKey('businessLandlordDetails'), isFalse);
    });

    test('SSN designation sends the SSN kind and residence months', () {
      final body = businessDetailsBody(
        completeStep1.copyWith(
          taxDesignation: TaxDesignation.llcSoleSsn,
          monthsAtResidence: 6,
        ),
      );
      expect((body['businessTaxDesignation'] as Map)['identifierKind'], 'SSN');
      expect((body['propertyStatus'] as Map)['monthsAtResidence'], 6);
    });
  });

  group('complianceBody', () {
    test('owner as officer is sent with their server id', () {
      final body = complianceBody(
        const OnboardingDraft(
          business: completeStep1,
          compliance: completeStep3,
          primaryOwnerId: 'owner-1',
        ),
      );
      expect(body['staff'], [
        {
          'firstName': 'Sam',
          'lastName': 'Cashier',
          'roleCode': 'TRANSACTION_PROCESSOR',
        },
        {
          'firstName': 'Alex',
          'lastName': 'Owner',
          'roleCode': 'COMPLIANCE_OFFICER',
          'businessOwnerId': 'owner-1',
        },
      ]);
    });

    test('another officer is sent by name', () {
      final body = complianceBody(
        OnboardingDraft(
          business: completeStep1,
          compliance: completeStep3.copyWith(
            complianceOfficerIsOwner: false,
            complianceOfficerFirstName: 'Casey',
            complianceOfficerLastName: 'Officer',
          ),
        ),
      );
      expect((body['staff'] as List).last, {
        'firstName': 'Casey',
        'lastName': 'Officer',
        'roleCode': 'COMPLIANCE_OFFICER',
      });
    });

    test('processors keep their order', () {
      final body = complianceBody(
        const OnboardingDraft(
          compliance: Step3ComplianceData(
            processors: [
              TransactionProcessor(id: 'a', firstName: 'A', lastName: '1'),
              TransactionProcessor(id: 'b', firstName: 'B', lastName: '2'),
            ],
          ),
        ),
      );
      final names = [
        for (final s in (body['staff'] as List).take(2))
          (s as Map)['firstName'],
      ];
      expect(names, ['A', 'B']);
    });
  });

  group('snapshotFromJson', () {
    test('reads status, number, date and open corrections', () {
      final snapshot = snapshotFromJson({
        'status': 'ACTION_REQUIRED',
        'statusLabel': 'Action Required',
        'applicationNumber': 'FP-APP-1',
        'submittedAt': '2026-11-16T08:23:30Z',
        'openCorrections': [
          {
            'correctionItemId': 'c1',
            'targetType': 'DOCUMENT_TYPE',
            'targetKey': 'PHOTO_EXTERIOR_ENTRANCE',
            'displayLabel': 'Exterior photo',
            'reason': 'Name not visible',
            'remediated': false,
          },
          {
            'correctionItemId': 'c2',
            'targetType': 'FIELD',
            'targetKey': 'personalBankName',
            'wizardStep': 'INITIAL_BUSINESS_DETAILS',
            'summaryMessage': 'Use the full bank name',
            'remediated': false,
          },
          {'correctionItemId': 'c3', 'remediated': true},
        ],
      });

      expect(snapshot.status, ApplicationStatus.actionRequired);
      expect(snapshot.applicationNumber, 'FP-APP-1');
      expect(
        snapshot.submittedAt?.toUtc(),
        DateTime.utc(2026, 11, 16, 8, 23, 30),
      );
      expect(snapshot.corrections, [
        const CorrectionItem(
          id: 'c1',
          label: 'Exterior photo',
          reason: 'Name not visible',
          documentType: 'PHOTO_EXTERIOR_ENTRANCE',
        ),
        const CorrectionItem(
          id: 'c2',
          label: '',
          reason: 'Use the full bank name',
          step: OnboardingStep.business,
        ),
      ]);
    });

    test('falls back to the label when the code is missing', () {
      expect(
        snapshotFromJson({'statusLabel': 'In Progress'}).status,
        ApplicationStatus.inProgress,
      );
      expect(snapshotFromJson({}).status, ApplicationStatus.draft);
    });
  });

  test('missingFromJson lists unique readable reasons', () {
    expect(
      missingFromJson({
        'onboardingCompletion': {
          'missingByStep': {
            'INITIAL_BUSINESS_DETAILS': ['Personal bank name is required.'],
            'REQUIRED_DOCUMENTS': [
              'Missing or invalid document: EIN_FORM',
              'Missing or invalid document: EIN_FORM',
            ],
          },
        },
      }),
      [
        'Personal bank name is required.',
        'Missing or invalid document: EIN_FORM',
      ],
    );
    expect(missingFromJson({}), isEmpty);
  });
}
