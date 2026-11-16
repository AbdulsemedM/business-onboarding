import 'package:business_onboarding/core/storage/draft_store.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';

/// In-memory [DraftStore] that records how many times it was saved.
///
/// [stored] is the most recently saved draft. A draft passed to the
/// constructor without an `applicationId` is handed to the first
/// application loaded, like a draft from an older build.
class FakeDraftStore implements DraftStore {
  FakeDraftStore([OnboardingDraft? initial]) {
    if (initial != null) {
      final id = initial.applicationId;
      if (id == null) {
        _unbound = initial;
      } else {
        drafts[id] = initial;
      }
      stored = initial;
    }
  }

  final drafts = <String, OnboardingDraft>{};
  OnboardingDraft? _unbound;
  OnboardingDraft? stored;
  int saveCount = 0;

  @override
  Future<OnboardingDraft?> load(String applicationId) async {
    final unbound = _unbound;
    if (!drafts.containsKey(applicationId) && unbound != null) {
      _unbound = null;
      drafts[applicationId] = unbound.copyWith(applicationId: applicationId);
    }
    return drafts[applicationId];
  }

  @override
  Future<void> save(OnboardingDraft draft) async {
    saveCount++;
    stored = draft;
    final id = draft.applicationId;
    if (id != null) drafts[id] = draft;
  }

  @override
  Future<void> clear(String applicationId) async {
    drafts.remove(applicationId);
    if (stored?.applicationId == applicationId) stored = null;
  }

  @override
  Future<void> clearAll() async {
    drafts.clear();
    _unbound = null;
    stored = null;
  }

  @override
  Future<void> retainOnly(Set<String> applicationIds) async =>
      drafts.removeWhere((id, _) => !applicationIds.contains(id));
}
