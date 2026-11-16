import 'package:business_onboarding/features/onboarding/step2_documents/logic/bill_date_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Afternoon, to check that the time of day is ignored.
  final now = DateTime(2026, 5, 31, 15, 30);

  group('last 60 days', () {
    const window = BillWindow.last60Days;

    test('accepts today and exactly 60 days ago', () {
      expect(window.check(DateTime(2026, 5, 31), now), isNull);
      expect(window.check(DateTime(2026, 4, 1), now), isNull);
    });

    test('rejects 61 days ago', () {
      expect(window.check(DateTime(2026, 3, 31), now), BillDateIssue.tooOld);
    });

    test('rejects tomorrow', () {
      expect(window.check(DateTime(2026, 6, 1), now), BillDateIssue.inFuture);
    });
  });

  group('last 90 days', () {
    const window = BillWindow.last90Days;

    test('accepts exactly 90 days ago', () {
      // 31 May 2026 minus 90 days.
      expect(window.earliestDate(now), DateTime(2026, 3, 2));
      expect(window.check(DateTime(2026, 3, 2), now), isNull);
    });

    test('rejects 91 days ago', () {
      expect(window.check(DateTime(2026, 3, 1), now), BillDateIssue.tooOld);
    });

    test('crosses the year boundary', () {
      expect(
        window.earliestDate(DateTime(2026, 1, 15)),
        DateTime(2025, 10, 17),
      );
    });

    test('a bill time later today is not in the future', () {
      expect(window.check(DateTime(2026, 5, 31, 23, 59), now), isNull);
    });
  });
}
