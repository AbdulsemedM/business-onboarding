import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/draft_store.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/safe_log.dart';
import '../data/models/onboarding_draft.dart';
import '../data/models/onboarding_step.dart';
import 'wizard_state.dart';

/// Owns the current step and the draft, and saves the draft to the device.
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

  Future<void> load() async {
    OnboardingDraft? saved;
    try {
      saved = await _draftStore.load();
    } catch (_) {
      safeLog('Draft load failed');
    }
    emit(
      state.copyWith(
        draft: saved ?? const OnboardingDraft(),
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

  /// Deletes the local draft and starts over.
  Future<void> discardDraft() async {
    _autosave.cancel();
    await _draftStore.clear();
    emit(const WizardState(isLoaded: true));
  }

  Future<void> _save() async {
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
