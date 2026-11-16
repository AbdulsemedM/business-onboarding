import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/brand_logo.dart';
import 'sign_out.dart';
import '../../onboarding/logic/wizard_cubit.dart';
import '../../onboarding/logic/wizard_state.dart';

/// Start screen: navy backdrop, the logo and title at the top, a white card
/// in the middle showing the four wizard steps, and the button at the bottom.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const maxContentWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppTheme.secondary,
        body: BlocBuilder<WizardCubit, WizardState>(
          builder: (context, state) {
            if (!state.isLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              );
            }
            // At least one screen tall, with the free space shared between
            // the hero, the card and the button; the page scrolls at large
            // text sizes.
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: BrandBackdrop(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: SafeArea(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: maxContentWidth,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _Hero(),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 28),
                                  child: _StepsCard(),
                                ),
                                _Actions(state: state),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The logo, the title and a one-line promise.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandBadge(size: 72),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            l10n.welcomeTitle,
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Sky blue on navy reads at about 5.5:1.
        Text(
          l10n.welcomeBody,
          style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.primary),
        ),
      ],
    );
  }
}

/// White card with the four steps as a connected 1-2-3-4 path, so it reads
/// as a guided wizard.
class _StepsCard extends StatelessWidget {
  const _StepsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final steps = [
      (Icons.storefront_rounded, l10n.welcomeStepBusiness),
      (Icons.upload_file_rounded, l10n.welcomeStepDocuments),
      (Icons.verified_user_rounded, l10n.welcomeStepCompliance),
      (Icons.send_rounded, l10n.welcomeStepSubmit),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.welcomeStepsHeading,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),
          for (final (i, (icon, label)) in steps.indexed) ...[
            _StepRow(
              number: i + 1,
              total: steps.length,
              icon: icon,
              label: label,
            ),
            if (i < steps.length - 1) const _Connector(),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.total,
    required this.icon,
    required this.label,
  });

  static const circleSize = 40.0;

  final int number;
  final int total;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Semantics(
      label: '${l10n.stepProgress(number, total)}: $label',
      excludeSemantics: true,
      child: Row(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppTheme.white),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
          // The step number, like a wizard's progress.
          Text(
            '$number/$total',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The line joining one step's circle to the next.
class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: _StepRow.circleSize / 2 - 1,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          width: 2,
          height: 14,
          margin: const EdgeInsets.symmetric(vertical: 2),
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

/// The main button and sign out, on the navy background.
class _Actions extends StatelessWidget {
  const _Actions({required this.state});

  final WizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          // After a submit the agent follows the review, not the wizard.
          onPressed: () => context.go(
            state.draft.submitted ? Routes.status : state.step.path,
          ),
          child: Text(
            state.draft.submitted
                ? l10n.statusViewStatus
                : state.hasSavedDraft
                ? l10n.continueApplication
                : l10n.startApplication,
          ),
        ),
        const SizedBox(height: 4),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppTheme.white),
          onPressed: () => confirmSignOut(context),
          child: Text(l10n.authSignOut),
        ),
      ],
    );
  }
}
