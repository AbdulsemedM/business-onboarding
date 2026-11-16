import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/features/onboarding/data/application_repository.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';

/// Returns [snapshot] from every call, or throws [failure] when set.
/// Records what was sent.
class FakeApplicationRepository implements ApplicationRepository {
  FakeApplicationRepository(this.snapshot);

  ApplicationSnapshot snapshot;
  AppFailure? failure;

  /// Returned by [resubmit] instead of [snapshot] when set.
  ApplicationSnapshot? afterResubmit;

  int submitCount = 0;
  List<String>? resubmittedIds;

  @override
  Future<ApplicationSnapshot> submit(OnboardingDraft draft) async {
    submitCount++;
    if (failure != null) throw failure!;
    return snapshot;
  }

  @override
  Future<ApplicationSnapshot> resubmit(List<String> ids) async {
    resubmittedIds = ids;
    if (failure != null) throw failure!;
    return afterResubmit ?? snapshot;
  }

  @override
  Future<ApplicationSnapshot> fetch() async {
    if (failure != null) throw failure!;
    return snapshot;
  }
}

const photoCorrection = CorrectionItem(
  id: 'c-photo',
  label: 'Exterior photo',
  reason: 'Business name not visible',
  documentType: 'PHOTO_EXTERIOR_ENTRANCE',
);

const actionRequired = ApplicationSnapshot(
  status: ApplicationStatus.actionRequired,
  applicationNumber: 'FP-1',
  corrections: [photoCorrection],
);

const inReview = ApplicationSnapshot(
  status: ApplicationStatus.resubmitted,
  applicationNumber: 'FP-1',
);
