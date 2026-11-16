import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import 'sign_out.dart';
import '../../onboarding/logic/wizard_cubit.dart';
import '../../onboarding/logic/wizard_state.dart';

// TODO(backend): add login once the auth method is known.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: BlocBuilder<WizardCubit, WizardState>(
        builder: (context, state) {
          if (!state.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // The header scrolls with the steps, so large text sizes never
              // overflow; only the button stays pinned at the bottom.
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const _Hero(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.welcomeStepsHeading,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          _StepRow(
                            number: 1,
                            icon: Icons.storefront_outlined,
                            title: l10n.stepBusinessTitle,
                            body: l10n.welcomeStep1Body,
                          ),
                          _StepRow(
                            number: 2,
                            icon: Icons.upload_file_outlined,
                            title: l10n.stepDocumentsTitle,
                            body: l10n.welcomeStep2Body,
                          ),
                          _StepRow(
                            number: 3,
                            icon: Icons.verified_user_outlined,
                            title: l10n.stepComplianceTitle,
                            body: l10n.welcomeStep3Body,
                          ),
                          _StepRow(
                            number: 4,
                            icon: Icons.fact_check_outlined,
                            title: l10n.stepReviewTitle,
                            body: l10n.welcomeStep4Body,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        // After a submit the merchant follows the review,
                        // not the wizard.
                        onPressed: () => context.go(
                          state.draft.submitted
                              ? Routes.status
                              : state.step.path,
                        ),
                        child: Text(
                          state.draft.submitted
                              ? l10n.statusViewStatus
                              : state.hasSavedDraft
                              ? l10n.continueApplication
                              : l10n.startApplication,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => confirmSignOut(context),
                        child: Text(l10n.authSignOut),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.welcomeSavedNote,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Brand header: blue to navy, with the title and a short intro in white.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.secondary],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: AppTheme.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.appTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                l10n.welcomeTitle,
                // Announced as a heading by screen readers.
                semanticsLabel: l10n.welcomeTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.welcomeBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.white.withValues(alpha: 0.88),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
    this.isLast = false,
  });

  final int number;
  final IconData icon;
  final String title;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Semantics(
      container: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: ExcludeSemantics(
                    child: Icon(icon, color: colors.primary, size: 22),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: colors.outlineVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(body, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
