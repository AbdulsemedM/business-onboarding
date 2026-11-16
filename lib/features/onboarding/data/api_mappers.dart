import '../../../core/utils/phone_validation.dart';
import '../step1_business/data/step1_business_data.dart';
import 'models/application_status.dart';
import 'models/onboarding_draft.dart';
import 'models/onboarding_step.dart';

/// Converts the draft into backend request bodies and backend responses
/// into app models. Shapes: docs/api/README.md.

const _days = [
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY',
];

String _time(int minutes) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(minutes ~/ 60)}:${two(minutes % 60)}:00';
}

String? _e164(String? number, String country) {
  if (number == null || number.trim().isEmpty) return null;
  final iso = isoCodeFrom(country);
  return iso == null ? number.trim() : (toE164(number, iso) ?? number.trim());
}

int? _totalMonths(int? years, int? months) =>
    years == null && months == null ? null : (years ?? 0) * 12 + (months ?? 0);

/// `POST .../onboarding/initial-business-details`.
Map<String, dynamic> businessDetailsBody(Step1BusinessData b) {
  final tax = b.taxDesignation;
  return {
    'operatingHours': {
      'intervals': [
        for (var day = 1; day <= 7; day++)
          if (b.openDays.contains(day) &&
              b.opensAt != null &&
              b.closesAt != null)
            {
              'dayOfWeek': _days[day - 1],
              'intervalIndex': 0,
              'opensAt': _time(b.opensAt!),
              'closesAt': _time(b.closesAt!),
              'closedAllDay': false,
            }
          else
            // The backend needs these two set even on closed days.
            {
              'dayOfWeek': _days[day - 1],
              'intervalIndex': 0,
              'closedAllDay': true,
            },
      ],
    },
    'monthsAtLocation': _totalMonths(b.yearsAtLocation, b.monthsAtLocation),
    'propertyStatus': {
      'businessLocationTenure': b.businessProperty?.apiCode,
      'residentialHomeTenure': b.residentialProperty?.apiCode,
      'monthsAtResidence': ?_totalMonths(
        b.yearsAtResidence,
        b.monthsAtResidence,
      ),
    },
    // Hidden landlord answers stay in the draft but are not sent.
    if (b.businessLandlordRequired)
      'businessLandlordDetails': {
        'name': b.businessLandlordName,
        'phone': _e164(
          b.businessLandlordPhoneNumber,
          b.businessLandlordPhoneCountry,
        ),
      },
    if (b.residentialLandlordRequired)
      'residentialLandlordDetails': {
        'name': b.residentialLandlordName,
        'phone': _e164(
          b.residentialLandlordPhoneNumber,
          b.residentialLandlordPhoneCountry,
        ),
      },
    'personalBankName': b.bankName,
    'businessTaxDesignation': {
      'taxClassificationCode': tax?.apiCode,
      'identifierKind': tax?.taxIdKind.apiCode,
      'identifierValue': b.taxId,
    },
    'businessLocationAddress': {
      'subtenant': b.subtenant,
      'line1': b.addressLine1,
      'line2': ?b.addressLine2,
      'city': b.city,
      'region': ?b.region,
      'postalCode': ?b.postalCode,
      'countryCode': b.countryCode,
    },
    'primaryOwner': {
      'ownerType': 'INDIVIDUAL',
      'firstName': b.ownerFirstName,
      'lastName': b.ownerLastName,
    },
  };
}

/// `POST/PUT .../owners` for partners after the first.
Map<String, dynamic> partnerBody({
  required String? firstName,
  required String? lastName,
}) => {'ownerType': 'INDIVIDUAL', 'firstName': firstName, 'lastName': lastName};

/// `POST .../onboarding/operations-compliance`. Replaces the whole list.
Map<String, dynamic> complianceBody(OnboardingDraft draft) {
  final c = draft.compliance;
  final b = draft.business;
  return {
    'staff': [
      for (final p in c.processors)
        {
          'firstName': p.firstName,
          'lastName': p.lastName,
          'roleCode': 'TRANSACTION_PROCESSOR',
        },
      if (c.complianceOfficerIsOwner)
        {
          'firstName': b.ownerFirstName,
          'lastName': b.ownerLastName,
          'roleCode': 'COMPLIANCE_OFFICER',
          'businessOwnerId': ?draft.primaryOwnerId,
        }
      else
        {
          'firstName': c.complianceOfficerFirstName,
          'lastName': c.complianceOfficerLastName,
          'roleCode': 'COMPLIANCE_OFFICER',
        },
    ],
  };
}

OnboardingStep? _stepFromApi(Object? wizardStep) => switch ('$wizardStep') {
  'INITIAL_BUSINESS_DETAILS' => OnboardingStep.business,
  'REQUIRED_DOCUMENTS' => OnboardingStep.documents,
  'OPERATIONS_AND_COMPLIANCE' => OnboardingStep.compliance,
  _ => null,
};

String? _text(Object? value) {
  final s = value?.toString().trim();
  return s == null || s.isEmpty ? null : s;
}

/// One open correction. Document corrections are recognised by a target
/// type mentioning DOCUMENT and a target key that is a document type code.
// TODO(api): confirm the targetType/targetKey values with the backend team.
CorrectionItem? correctionFromJson(Map<String, dynamic> json) {
  if (json['remediated'] == true) return null;
  final id = _text(json['correctionItemId']);
  if (id == null) return null;
  final targetType = '${json['targetType'] ?? ''}'.toUpperCase();
  final targetKey = _text(json['targetKey']);
  final isDocument =
      targetType.contains('DOCUMENT') &&
      targetKey != null &&
      RegExp(r'^[A-Z0-9_]+$').hasMatch(targetKey);
  return CorrectionItem(
    id: id,
    label:
        _text(json['displayLabel']) ??
        _text(json['targetKeyLabel']) ??
        _text(json['targetTypeLabel']) ??
        _text(json['wizardStepLabel']) ??
        '',
    reason:
        _text(json['reason']) ??
        _text(json['summaryMessage']) ??
        _text(json['instructions']) ??
        '',
    documentType: isDocument ? targetKey : null,
    step: isDocument
        ? null
        : (_stepFromApi(json['wizardStep']) ?? OnboardingStep.business),
  );
}

/// `GET .../applications/{id}` data -> what the status screen needs.
ApplicationSnapshot snapshotFromJson(Map<String, dynamic> data) {
  final corrections = (data['openCorrections'] as List?) ?? const [];
  return ApplicationSnapshot(
    status:
        ApplicationStatus.fromApi(data['status'] as String?) ??
        ApplicationStatus.fromApi(data['statusLabel'] as String?) ??
        ApplicationStatus.draft,
    applicationNumber: _text(data['applicationNumber']),
    submittedAt: DateTime.tryParse('${data['submittedAt'] ?? ''}')?.toLocal(),
    corrections: [
      for (final c in corrections.whereType<Map<String, dynamic>>())
        ?correctionFromJson(c),
    ],
  );
}

/// Readable "still missing" sentences from `onboardingCompletion`, shown
/// when a submit is refused.
List<String> missingFromJson(Map<String, dynamic> data) {
  final completion = data['onboardingCompletion'];
  if (completion is! Map<String, dynamic>) return const [];
  final missing = completion['missingByStep'];
  if (missing is! Map<String, dynamic>) return const [];
  return <String>{
    for (final list in missing.values)
      if (list is List)
        for (final item in list) ?_text(item),
  }.toList();
}
