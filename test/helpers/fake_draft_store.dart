import 'package:business_onboarding/core/storage/draft_store.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';

/// In-memory [DraftStore] that records how many times it was saved.
class FakeDraftStore implements DraftStore {
  FakeDraftStore([this.stored]);

  OnboardingDraft? stored;
  int saveCount = 0;

  @override
  Future<OnboardingDraft?> load() async => stored;

  @override
  Future<void> save(OnboardingDraft draft) async {
    saveCount++;
    stored = draft;
  }

  @override
  Future<void> clear() async => stored = null;
}
