import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

/// "820 KB" or "2.4 MB".
String formatFileSize(int bytes, AppLocalizations l10n) {
  final number = NumberFormat('#,##0.#', l10n.localeName);
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes >= mb) return l10n.fileSizeMb(number.format(bytes / mb));
  return l10n.fileSizeKb(number.format((bytes / kb).ceil()));
}
