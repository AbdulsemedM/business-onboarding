import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../data/models/onboarding_step.dart';
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

  void _goBack() {
    final previous = _step.previous;
    if (previous == null) {
      context.go(Routes.welcome);
      return;
    }
    _goTo(previous);
  }

  void _goNext() {
    FocusScope.of(context).unfocus();
    if (!_validation.validate()) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).fixErrorsMessage),
          ),
        );
      return;
    }
    final next = _step.next;
    if (next != null) _goTo(next);
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
    );
  }

  Widget _buttons(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(onPressed: _goBack, child: Text(l10n.back)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _step.isLast
                // TODO(review): wire up submit in build step 7.
                ? FilledButton(onPressed: null, child: Text(l10n.submit))
                : FilledButton(onPressed: _goNext, child: Text(l10n.next)),
          ),
        ],
      ),
    );
  }
}
