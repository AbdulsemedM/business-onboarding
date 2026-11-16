import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/draft_store.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/safe_log.dart';
import '../data/models/onboarding_draft.dart';
import '../data/models/onboarding_step.dart';
import 'wizard_state.dart';

/// Owns the current step and the open application's draft, and saves the
/// draft to the device. Each application has its own draft; [open] switches
/// between them.
///
/// Field changes are saved after a short pause ([autosaveDelay]).
/// Step changes are saved right away.
class WizardCubit extends Cubit<WizardState> {
  WizardCubit({
    required DraftStore draftStore,
    Duration autosaveDelay = const Duration(milliseconds: 600),
  }) : _draftStore = draftStore,
       _autosave = Debouncer(autosaveDelay),
       super(const WizardState());

  final DraftStore _draftStore;
  final Debouncer _autosave;

  /// Loads [applicationId]'s draft, saving the one that was open first.
  Future<void> open(String applicationId) async {
    if (state.isLoaded && state.draft.applicationId == applicationId) return;
    if (state.isLoaded) {
      await saveNow();
      // Hide the old draft while the new one loads.
      emit(const WizardState());
    }
    OnboardingDraft? saved;
    try {
      saved = await _draftStore.load(applicationId);
    } catch (_) {
      safeLog('Draft load failed');
    }
    emit(
      WizardState(
        draft: (saved ?? const OnboardingDraft()).copyWith(
          applicationId: applicationId,
        ),
        isLoaded: true,
        hasSavedDraft: saved != null,
      ),
    );
  }

  Future<void> goTo(OnboardingStep step) async {
    if (step == state.step) return;
    emit(state.copyWith(draft: state.draft.copyWith(currentStep: step)));
    await saveNow();
  }

  /// Applies a change to the draft and schedules an autosave.
  void updateDraft(OnboardingDraft Function(OnboardingDraft draft) update) {
    emit(state.copyWith(draft: update(state.draft)));
    _autosave.run(_save);
  }

  /// Saves immediately, cancelling any scheduled autosave.
  /// Called on step change and when the app goes to the background.
  Future<void> saveNow() {
    _autosave.cancel();
    return _save();
  }

  /// Records a successful submit and saves straight away.
  Future<void> markSubmitted() async {
    emit(state.copyWith(draft: state.draft.copyWith(submitted: true)));
    await saveNow();
  }

  /// Deletes the open application's draft and starts it over.
  Future<void> discardDraft() async {
    _autosave.cancel();
    final id = state.draft.applicationId;
    if (id != null) await _draftStore.clear(id);
    emit(
      WizardState(isLoaded: true, draft: OnboardingDraft(applicationId: id)),
    );
  }

  /// Deletes every draft on the device (sign out).
  Future<void> discardAllDrafts() async {
    _autosave.cancel();
    await _draftStore.clearAll();
    emit(const WizardState());
  }

  /// Drops drafts for applications not on the signed-in account, so one
  /// account never keeps another's answers on the device.
  Future<void> retainDrafts(Set<String> applicationIds) async {
    try {
      await _draftStore.retainOnly(applicationIds);
    } catch (_) {
      safeLog('Draft cleanup failed');
    }
  }

  Future<void> _save() async {
    // Nothing is open yet (before sign-in or between applications).
    if (!state.isLoaded) return;
    try {
      await _draftStore.save(state.draft);
    } catch (_) {
      safeLog('Draft save failed');
    }
  }

  @override
  Future<void> close() async {
    if (_autosave.isPending) await saveNow();
    return super.close();
  }
}
