import '../../l10n/app_localizations.dart';
import 'app_failure.dart';

extension AppFailureMessage on AppFailure {
  String message(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    TimeoutFailure() => l10n.errorTimeout,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    ValidationFailure() => l10n.errorValidation,
    ServerFailure() => l10n.errorServer,
    UnknownFailure() => l10n.errorUnknown,
  };
}
