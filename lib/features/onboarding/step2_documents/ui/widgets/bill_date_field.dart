import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../logic/bill_date_rules.dart';

/// Date printed on a utility bill. Must fall inside [window].
class BillDateField extends StatelessWidget {
  const BillDateField({
    super.key,
    required this.name,
    required this.window,
    required this.initialValue,
    required this.onChanged,
  });

  final String name;
  final BillWindow window;
  final DateTime? initialValue;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = dateOnly(now);
    final saved = initialValue;

    // The picker only offers valid dates. A saved date that has since gone
    // out of range must still fit, or the picker can't open on it; the
    // validator then explains the problem.
    final earliest = window.earliestDate(now);
    final firstDate = saved != null && saved.isBefore(earliest)
        ? saved
        : earliest;
    final lastDate = saved != null && saved.isAfter(today) ? saved : today;

    return FormBuilderDateTimePicker(
      name: name,
      inputType: InputType.date,
      format: DateFormat.yMMMd(Localizations.localeOf(context).toString()),
      initialValue: saved,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: today,
      decoration: InputDecoration(
        labelText: l10n.step2BillDate,
        suffixIcon: const Icon(Icons.event),
      ),
      validator: (date) {
        if (date == null) return l10n.errorRequired;
        return switch (window.check(date, DateTime.now())) {
          null => null,
          BillDateIssue.inFuture => l10n.errorBillDateFuture,
          BillDateIssue.tooOld => switch (window) {
            BillWindow.last60Days => l10n.errorBillOlderThan60Days,
            BillWindow.last90Days => l10n.errorBillOlderThan90Days,
          },
        };
      },
      onChanged: (date) => onChanged(date == null ? null : dateOnly(date)),
    );
  }
}
