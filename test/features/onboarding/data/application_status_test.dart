import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses backend codes and display labels', () {
    expect(ApplicationStatus.fromApi('DRAFT'), ApplicationStatus.draft);
    // The list endpoint returns labels, the detail endpoint codes.
    expect(ApplicationStatus.fromApi('Draft'), ApplicationStatus.draft);
    expect(
      ApplicationStatus.fromApi('Action Required'),
      ApplicationStatus.actionRequired,
    );
    expect(
      ApplicationStatus.fromApi('IN_PROGRESS'),
      ApplicationStatus.inProgress,
    );
    expect(
      ApplicationStatus.fromApi(' resubmitted '),
      ApplicationStatus.resubmitted,
    );
  });

  test('unknown or missing values give null', () {
    expect(ApplicationStatus.fromApi(null), isNull);
    expect(ApplicationStatus.fromApi('ARCHIVED'), isNull);
  });

  test('submitted and resubmitted count as in review', () {
    expect(ApplicationStatus.values.where((s) => s.isInReview), [
      ApplicationStatus.submitted,
      ApplicationStatus.resubmitted,
    ]);
  });
}
