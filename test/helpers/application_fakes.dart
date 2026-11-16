import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/features/onboarding/data/application_repository.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';

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

  /// Calls to the per-step saves, in order, e.g. "business", "partner".
  final List<String> saves = [];
  OnboardingDraft? savedCompliance;
  final List<String> removedPartners = [];
  int _nextOwner = 2;

  @override
  Future<String> saveBusinessDetails(Step1BusinessData business) async {
    saves.add('business');
    if (failure != null) throw failure!;
    return 'owner-1';
  }

  @override
  Future<String> savePartner({
    String? ownerId,
    required String? firstName,
    required String? lastName,
  }) async {
    saves.add('partner');
    if (failure != null) throw failure!;
    return ownerId ?? 'owner-${_nextOwner++}';
  }

  @override
  Future<void> removePartner(String ownerId) async {
    if (failure != null) throw failure!;
    removedPartners.add(ownerId);
  }

  @override
  Future<void> saveCompliance(OnboardingDraft draft) async {
    saves.add('compliance');
    if (failure != null) throw failure!;
    savedCompliance = draft;
  }

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
