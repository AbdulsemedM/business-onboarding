import 'package:flutter/foundation.dart';

/// Debug-only logger.
///
/// Only pass fixed, developer-written messages. Never pass personal data,
/// tokens, file names, form values, or raw server responses.
void safeLog(String message) {
  if (kDebugMode) {
    debugPrint('[FastPay] $message');
  }
}
