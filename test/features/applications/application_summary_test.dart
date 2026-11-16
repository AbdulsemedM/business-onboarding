import 'package:business_onboarding/features/applications/data/application_summary.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads a list item with a display-label status', () {
    final app = ApplicationSummary.fromJson({
      'id': 'app-1',
      'applicationNumber': 'APP-0001',
      'businessName': 'Corner Market',
      'status': 'In Progress',
      'hasOpenCorrections': false,
      'createdAt': '2026-11-01T10:00:00Z',
    });
    expect(app.id, 'app-1');
    expect(app.applicationNumber, 'APP-0001');
    expect(app.businessName, 'Corner Market');
    expect(app.status, ApplicationStatus.inProgress);
    expect(app.createdAt, DateTime.utc(2026, 11, 1, 10));
    expect(app.isSubmitted, isFalse);
  });

  test('open corrections mean action required', () {
    final app = ApplicationSummary.fromJson({
      'id': 'app-1',
      'businessName': 'Corner Market',
      'status': 'Submitted',
      'hasOpenCorrections': true,
    });
    expect(app.status, ApplicationStatus.actionRequired);
    expect(app.isSubmitted, isTrue);
  });

  test('an unknown status is kept as null and treated as not submitted', () {
    final app = ApplicationSummary.fromJson({
      'id': 'app-1',
      'businessName': 'Corner Market',
      'status': 'Archived',
    });
    expect(app.status, isNull);
    expect(app.isSubmitted, isFalse);
  });
}
