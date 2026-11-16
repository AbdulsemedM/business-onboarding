enum BillDateIssue { inFuture, tooOld }

/// How recent a utility bill must be, based on the bill date the user enters.
enum BillWindow {
  /// Home utility bill for a partner whose ID is a passport or lists a
  /// P.O. Box.
  last60Days,

  /// Business utility bill. The backend allows 90 days (`maxAgeDays`).
  last90Days;

  /// The oldest bill date still accepted on [now]'s calendar day.
  DateTime earliestDate(DateTime now) {
    final today = dateOnly(now);
    return switch (this) {
      // Built from parts (not Duration) so daylight saving can't shift it.
      last60Days => DateTime(today.year, today.month, today.day - 60),
      last90Days => DateTime(today.year, today.month, today.day - 90),
    };
  }

  /// Returns null if [billDate] is acceptable on [now].
  BillDateIssue? check(DateTime billDate, DateTime now) {
    final date = dateOnly(billDate);
    if (date.isAfter(dateOnly(now))) return BillDateIssue.inFuture;
    if (date.isBefore(earliestDate(now))) return BillDateIssue.tooOld;
    return null;
  }
}

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
