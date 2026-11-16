import 'models/application_status.dart';
import 'models/onboarding_draft.dart';
import 'models/onboarding_step.dart';

/// Submitting the application and reading its review status.
///
/// Real API (docs/api/README.md): `POST .../applications/{id}/submit` for
/// both first submit and resubmit, and `GET .../applications/{id}` for the
/// status and `openCorrections`.
abstract interface class ApplicationRepository {
  /// First submit. Throws an [AppFailure] on error.
  Future<ApplicationSnapshot> submit(OnboardingDraft draft);

  /// Resubmit after corrections. [addressedCorrectionIds] must contain every
  /// open correction id. Throws an [AppFailure] on error.
  Future<ApplicationSnapshot> resubmit(List<String> addressedCorrectionIds);

  /// Current status. Throws an [AppFailure] on error.
  Future<ApplicationSnapshot> fetch();
}

/// Stands in for the API until it is wired.
///
/// To show the re-upload flow, the first submit comes back as "action
/// required" with one rejected photo ([sampleCorrections]). Resubmitting
/// clears it. Pass [corrections] to try other cases (e.g. a field to fix).
// TODO(api): replace with the real repository.
class MockApplicationRepository implements ApplicationRepository {
  MockApplicationRepository({
    this.delay = const Duration(milliseconds: 900),
    this.corrections = sampleCorrections,
  });

  final Duration delay;
  final List<CorrectionItem> corrections;
  ApplicationSnapshot? _current;

  static const sampleFieldCorrection = CorrectionItem(
    id: 'mock-correction-bank',
    label: 'Personal bank name',
    reason: 'Enter the full name of your bank as it appears on statements.',
    step: OnboardingStep.business,
  );

  static const sampleCorrections = [
    CorrectionItem(
      id: 'mock-correction-photo',
      label: 'Exterior photo',
      reason:
          'The business name is not visible. Retake the photo from across '
          'the street so the sign and street number are both in view.',
      documentType: 'PHOTO_EXTERIOR_ENTRANCE',
    ),
  ];

  @override
  Future<ApplicationSnapshot> submit(OnboardingDraft draft) async {
    await Future<void>.delayed(delay);
    final previous = _current;
    // A second submit (after fixing a field in the wizard) is a resubmit.
    if (previous != null && previous.corrections.isNotEmpty) {
      return resubmit([for (final c in previous.corrections) c.id]);
    }
    return _current = ApplicationSnapshot(
      status: ApplicationStatus.actionRequired,
      applicationNumber: 'FP-APP-DEMO',
      submittedAt: DateTime.now(),
      corrections: corrections,
    );
  }

  @override
  Future<ApplicationSnapshot> resubmit(
    List<String> addressedCorrectionIds,
  ) async {
    await Future<void>.delayed(delay);
    return _current = ApplicationSnapshot(
      status: ApplicationStatus.resubmitted,
      applicationNumber: _current?.applicationNumber ?? 'FP-APP-DEMO',
      submittedAt: DateTime.now(),
    );
  }

  @override
  Future<ApplicationSnapshot> fetch() async {
    await Future<void>.delayed(delay ~/ 2);
    return _current ??
        ApplicationSnapshot(
          status: ApplicationStatus.submitted,
          applicationNumber: 'FP-APP-DEMO',
          submittedAt: DateTime.now(),
        );
  }
}
