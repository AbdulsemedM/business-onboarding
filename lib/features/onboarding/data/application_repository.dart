import 'package:dio/dio.dart';

import '../../../core/utils/safe_log.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/interceptors/error_interceptor.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/storage/session_store.dart';
import '../step1_business/data/step1_business_data.dart';
import 'api_mappers.dart';
import 'models/application_status.dart';
import 'models/onboarding_draft.dart';
import 'models/onboarding_step.dart';

/// Saving the application to the server, submitting it, and reading its
/// review status. Errors are thrown as [AppFailure].
///
/// API (docs/api/README.md): one POST per step, owners CRUD, a single
/// `POST .../submit` for submit and resubmit, `GET .../applications/{id}`.
abstract interface class ApplicationRepository {
  /// Saves Step 1. Returns the primary owner's server id.
  Future<String> saveBusinessDetails(Step1BusinessData business);

  /// Creates ([ownerId] null) or updates a partner after the first.
  /// Returns the server owner id.
  Future<String> savePartner({
    String? ownerId,
    required String? firstName,
    required String? lastName,
  });

  Future<void> removePartner(String ownerId);

  /// Saves Step 3 (replaces the whole staff list).
  Future<void> saveCompliance(OnboardingDraft draft);

  /// First submit. A refused submit throws [ValidationFailure] whose
  /// messages say what is still missing.
  Future<ApplicationSnapshot> submit(OnboardingDraft draft);

  /// Resubmit after corrections. [addressedCorrectionIds] must contain every
  /// open correction id.
  Future<ApplicationSnapshot> resubmit(List<String> addressedCorrectionIds);

  /// Current status.
  Future<ApplicationSnapshot> fetch();
}

class ApiApplicationRepository implements ApplicationRepository {
  ApiApplicationRepository({
    required Dio dio,
    required SessionStore sessionStore,
  }) : _dio = dio,
       _session = sessionStore;

  final Dio _dio;
  final SessionStore _session;

  Future<String> _base() async {
    final id = (await _session.read())?.applicationId;
    if (id == null) throw const AppFailure.unauthorized();
    return '/api/v1/partner/applications/$id';
  }

  @override
  Future<String> saveBusinessDetails(Step1BusinessData business) =>
      _guard(() async {
        final base = await _base();
        final response = await _dio.post<dynamic>(
          '$base/onboarding/initial-business-details',
          data: businessDetailsBody(business),
        );
        final ownerId = dataOf(response)['ownerId'] as String?;
        if (ownerId != null) return ownerId;
        // Fallback: read the owner from the application.
        final detail = dataOf(await _dio.get<dynamic>(base));
        final owners = (detail['owners'] as List?) ?? const [];
        final first = owners.whereType<Map<String, dynamic>>().firstOrNull;
        final id = first?['id'] as String?;
        if (id == null) throw const AppFailure.server();
        return id;
      });

  @override
  Future<String> savePartner({
    String? ownerId,
    required String? firstName,
    required String? lastName,
  }) => _guard(() async {
    final base = await _base();
    final body = partnerBody(firstName: firstName, lastName: lastName);
    if (ownerId != null) {
      await _dio.put<dynamic>('$base/owners/$ownerId', data: body);
      return ownerId;
    }
    final response = await _dio.post<dynamic>('$base/owners', data: body);
    final data = dataOf(response);
    final id = (data['ownerId'] ?? data['id']) as String?;
    if (id == null) throw const AppFailure.server();
    return id;
  });

  @override
  Future<void> removePartner(String ownerId) => _guard(() async {
    await _dio.delete<dynamic>('${await _base()}/owners/$ownerId');
  });

  @override
  Future<void> saveCompliance(OnboardingDraft draft) => _guard(() async {
    await _dio.post<dynamic>(
      '${await _base()}/onboarding/operations-compliance',
      data: complianceBody(draft),
    );
  });

  @override
  Future<ApplicationSnapshot> submit(OnboardingDraft draft) =>
      _submit(const {}, localExteriorId: draft.documents.exteriorPhoto?.id);

  @override
  Future<ApplicationSnapshot> resubmit(List<String> ids) =>
      _submit({'addressedCorrectionItemIds': ids});

  Future<ApplicationSnapshot> _submit(
    Map<String, dynamic> body, {
    String? localExteriorId,
  }) => _guard(() async {
    final base = await _base();
    try {
      await _dio.post<dynamic>('$base/submit', data: body);
    } on DioException catch (error) {
      final failure = failureFrom(error);
      if (failure is! ValidationFailure) rethrow;
      // Say what is missing, in the server's own readable words.
      final detail = dataOf(await _dio.get<dynamic>(base));
      _debugPhotos(detail, localExteriorId); // TEMP(diagnostic)
      throw AppFailure.validation(messages: missingFromJson(detail));
    }
    return snapshotFromJson(dataOf(await _dio.get<dynamic>(base)));
  });

  @override
  Future<ApplicationSnapshot> fetch() => _guard(() async {
    return snapshotFromJson(dataOf(await _dio.get<dynamic>(await _base())));
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw failureFrom(error);
    }
  }

  // TEMP(diagnostic): remove after finding why the exterior photo isn't
  // counted. Logs only codes, flags and counts (debug builds only).
  void _debugPhotos(Map<String, dynamic> detail, String? localExteriorId) {
    final docs = detail['requiredDocuments'];
    final photos = docs is Map ? docs['businessPhotos'] : null;
    if (photos is! Map) {
      safeLog('DIAG businessPhotos section missing');
      return;
    }
    for (final slot in (photos['slots'] as List? ?? const [])) {
      if (slot is! Map) continue;
      safeLog(
        'DIAG slot ${slot['documentTypeCode']} required=${slot['required']} '
        'satisfied=${slot['satisfied']} count=${slot['submittedCount']}',
      );
    }
    final subs = (photos['submissions'] as List? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .toList();
    for (final sub in subs) {
      final reasons = sub['correctionReasons'];
      // Field names, plus values of status-like fields (no names or ids).
      final statusLike = {
        for (final e in sub.entries)
          if (RegExp(
            'status|state|verif|upload|active|current|latest|superseded',
            caseSensitive: false,
          ).hasMatch('${e.key}'))
            '${e.key}': e.value is String || e.value is bool || e.value is num
                ? e.value
                : e.value.runtimeType,
      };
      safeLog(
        'DIAG submission ${sub['documentTypeCode']} '
        'requiresCorrection=${sub['requiresCorrection']} '
        'reasons=${reasons is List ? reasons.length : 0} '
        'isLocal=${sub['id'] == localExteriorId} '
        'keys=${sub.keys.join(',')} status=$statusLike',
      );
    }
    safeLog(
      'DIAG local exterior photo present=${localExteriorId != null} '
      'onServer=${subs.any((s) => s['id'] == localExteriorId)}',
    );
    final missing = detail['onboardingCompletion'];
    final byStep = missing is Map ? missing['missingByStep'] : null;
    final docMissing = byStep is Map ? byStep['REQUIRED_DOCUMENTS'] : null;
    safeLog(
      'DIAG missing docs count=${docMissing is List ? docMissing.length : 0}',
    );
  }
}

/// Stands in for the API when no API_BASE_URL is set.
///
/// To show the re-upload flow, the first submit comes back as "action
/// required" with one rejected photo ([sampleCorrections]). Resubmitting
/// clears it. Pass [corrections] to try other cases (e.g. a field to fix).
class MockApplicationRepository implements ApplicationRepository {
  MockApplicationRepository({
    this.delay = const Duration(milliseconds: 900),
    this.corrections = sampleCorrections,
  });

  final Duration delay;
  final List<CorrectionItem> corrections;
  ApplicationSnapshot? _current;
  int _nextOwner = 2;

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
  Future<String> saveBusinessDetails(Step1BusinessData business) async =>
      'mock-owner-1';

  @override
  Future<String> savePartner({
    String? ownerId,
    required String? firstName,
    required String? lastName,
  }) async => ownerId ?? 'mock-owner-${_nextOwner++}';

  @override
  Future<void> removePartner(String ownerId) async {}

  @override
  Future<void> saveCompliance(OnboardingDraft draft) async {}

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
