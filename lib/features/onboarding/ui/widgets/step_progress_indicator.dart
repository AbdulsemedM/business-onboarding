import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/models/onboarding_step.dart';
import '../step_titles.dart';

/// "Step 2 of 4" with one segment per step. Read as one label by screen
/// readers.
class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({super.key, required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final total = OnboardingStep.values.length;

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: l10n.stepProgressSemantics(step.number, total, step.title(l10n)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Wraps onto two lines at large text sizes instead of overflowing.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 2,
            children: [
              Text(
                l10n.stepProgress(step.number, total),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                ),
              ),
              if (step.next case final next?)
                Text(
                  l10n.stepUpNext(next.title(l10n)),
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 1; i <= total; i++) ...[
                if (i > 1) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= step.number
                          ? colors.primary
                          : colors.primaryContainer,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
