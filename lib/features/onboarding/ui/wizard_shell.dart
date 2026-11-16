import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/utils/safe_log.dart';
import '../data/application_repository.dart';
import '../data/models/onboarding_step.dart';
import '../review/logic/submit_cubit.dart';
import '../logic/step_validation.dart';
import '../logic/wizard_cubit.dart';
import 'step_titles.dart';
import 'widgets/step_progress_indicator.dart';

/// Frame around every wizard step: title, progress, and Back/Next buttons.
///
/// The URL decides which step is shown; the cubit records it in the draft.
/// Next only moves on if the current step's [StepValidation] passes.
class WizardShell extends StatefulWidget {
  const WizardShell({super.key, required this.step, required this.child});

  final OnboardingStep step;
  final Widget child;

  @override
  State<WizardShell> createState() => _WizardShellState();
}

class _WizardShellState extends State<WizardShell> {
  final _validation = StepValidation();

  OnboardingStep get _step => widget.step;

  /// The current step is being saved to the server.
  bool _saving = false;

  void _goBack() {
    final previous = _step.previous;
    if (previous == null) {
      context.go(Routes.welcome);
      return;
    }
    _goTo(previous);
  }

  Future<void> _goNext() async {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_validation.validate()) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.fixErrorsMessage)));
      return;
    }
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await _saveStep(_step);
    } on AppFailure catch (failure) {
      // The draft is kept on the device; the user can retry when ready.
      safeLog('Step save failed: ${failure.runtimeType}');
      if (mounted) _showFailure(failure);
      return;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    final next = _step.next;
    if (next != null && mounted) _goTo(next);
  }

  /// Saves what the step collected. Steps that save as they go (uploads)
  /// only make sure their partners exist on the server.
  Future<void> _saveStep(OnboardingStep step) async {
    final wizard = context.read<WizardCubit>();
    final repository = context.read<ApplicationRepository>();
    final draft = wizard.state.draft;
    switch (step) {
      case OnboardingStep.business:
        final ownerId = await repository.saveBusinessDetails(draft.business);
        wizard.updateDraft((d) => d.copyWith(primaryOwnerId: ownerId));
      case OnboardingStep.documents:
        for (final partner in draft.documents.partners.skip(1)) {
          final ownerId = await repository.savePartner(
            ownerId: partner.ownerId,
            firstName: partner.firstName,
            lastName: partner.lastName,
          );
          wizard.updateDraft(
            (d) => d.copyWith(
              documents: d.documents.withPartnerUpdated(
                partner.id,
                (p) => p.copyWith(ownerId: ownerId),
              ),
            ),
          );
        }
      case OnboardingStep.compliance:
        // "Same as owner" needs the owner's server id.
        if (draft.primaryOwnerId == null) {
          final ownerId = await repository.saveBusinessDetails(draft.business);
          wizard.updateDraft((d) => d.copyWith(primaryOwnerId: ownerId));
        }
        await repository.saveCompliance(wizard.state.draft);
      case OnboardingStep.review:
        break;
    }
  }

  /// A refused save or submit lists the server's reasons when it gives any.
  void _showFailure(AppFailure failure) {
    final l10n = AppLocalizations.of(context);
    final reasons = failure is ValidationFailure ? failure.messages : const [];
    if (reasons.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message(l10n))));
      return;
    }
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.checklist_rounded),
        title: Text(l10n.stillMissingTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final reason in reasons)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('• $reason'),
                ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _goTo(OnboardingStep target) {
    context.read<WizardCubit>().goTo(target);
    context.go(target.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoaded = context.select<WizardCubit, bool>(
      (cubit) => cubit.state.isLoaded,
    );

    return RepositoryProvider.value(
      value: _validation,
      child: BlocProvider(
        create: (context) =>
            SubmitCubit(repository: context.read<ApplicationRepository>()),
        child: BlocListener<SubmitCubit, SubmitState>(
          listener: _onSubmitState,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _goBack();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(_step.title(l10n)),
                automaticallyImplyLeading: false,
              ),
              // In bottomNavigationBar (not the body) so snack bars appear above
              // the buttons instead of covering them.
              bottomNavigationBar: SafeArea(child: _buttons(l10n)),
              body: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: StepProgressIndicator(step: _step),
                    ),
                    // The step content is a nested Navigator whose route barrier
                    // uses BlockSemantics. Its own container stops that barrier
                    // from hiding the progress header from screen readers.
                    Expanded(
                      child: Semantics(
                        container: true,
                        // Forms read their initial values from the draft, so
                        // wait until it has been loaded from the device.
                        child: isLoaded
                            ? widget.child
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmitState(BuildContext context, SubmitState state) async {
    switch (state) {
      case SubmitSucceeded(:final snapshot):
        await context.read<WizardCubit>().markSubmitted();
        if (context.mounted) context.go(Routes.status, extra: snapshot);
      case SubmitFailed(:final failure):
        _showFailure(failure);
      case SubmitIdle() || SubmitInProgress():
        break;
    }
  }

  Future<void> _confirmAndSubmit(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final submit = context.read<SubmitCubit>();
    final wizard = context.read<WizardCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.send_rounded),
        title: Text(l10n.submitConfirmTitle),
        content: Text(l10n.submitConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.submitConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await submit.submit(wizard.state.draft);
  }

  Widget _buttons(AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(onPressed: _goBack, child: Text(l10n.back)),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: _step.isLast
                  ? BlocBuilder<SubmitCubit, SubmitState>(
                      builder: (context, state) => state is SubmitInProgress
                          ? FilledButton.icon(
                              onPressed: null,
                              icon: const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              label: Text(l10n.submitting),
                            )
                          : FilledButton(
                              onPressed: () => _confirmAndSubmit(context),
                              child: Text(l10n.submit),
                            ),
                    )
                  : _saving
                  ? FilledButton.icon(
                      onPressed: null,
                      icon: const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      label: Text(l10n.saving),
                    )
                  : FilledButton(onPressed: _goNext, child: Text(l10n.next)),
            ),
          ],
        ),
      ),
    );
  }
}
