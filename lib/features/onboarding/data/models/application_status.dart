import 'package:freezed_annotation/freezed_annotation.dart';

import 'onboarding_step.dart';

part 'application_status.freezed.dart';

/// Backend application status (see docs/api/README.md).
enum ApplicationStatus {
  draft,
  inProgress,
  actionRequired,
  submitted,
  resubmitted,
  approved,
  rejected;

  /// Accepts the code (`ACTION_REQUIRED`) or the display label
  /// (`Action Required`): the list endpoint returns labels.
  static ApplicationStatus? fromApi(String? value) {
    if (value == null) return null;
    final code = value.trim().toUpperCase().replaceAll(RegExp(r'[\s-]+'), '_');
    return switch (code) {
      'DRAFT' => draft,
      'IN_PROGRESS' => inProgress,
      'ACTION_REQUIRED' => actionRequired,
      'SUBMITTED' => submitted,
      'RESUBMITTED' => resubmitted,
      'APPROVED' => approved,
      'REJECTED' => rejected,
      _ => null,
    };
  }

  /// Waiting for the reviewer: nothing for the merchant to do.
  bool get isInReview => this == submitted || this == resubmitted;
}

/// One thing the reviewer asked the merchant to fix (backend
/// `openCorrections[]`).
@freezed
abstract class CorrectionItem with _$CorrectionItem {
  const factory CorrectionItem({
    /// Backend `correctionItemId`, sent back on resubmit.
    required String id,

    /// What needs fixing, e.g. "Exterior photo". From the server.
    required String label,

    /// Why, e.g. "Business name is not visible". From the server.
    required String reason,

    /// Set when a document must be uploaded again: the backend document
    /// type code to upload it as.
    String? documentType,

    /// Set when a form field must be changed: the step that has it.
    OnboardingStep? step,
  }) = _CorrectionItem;

  const CorrectionItem._();

  bool get isDocument => documentType != null;
}

/// What the status screen shows (subset of backend GET application).
@freezed
abstract class ApplicationSnapshot with _$ApplicationSnapshot {
  const factory ApplicationSnapshot({
    required ApplicationStatus status,
    String? applicationNumber,
    DateTime? submittedAt,
    @Default(<CorrectionItem>[]) List<CorrectionItem> corrections,
  }) = _ApplicationSnapshot;
}
