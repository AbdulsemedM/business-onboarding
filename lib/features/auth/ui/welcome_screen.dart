import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/logic/wizard_cubit.dart';
import '../../onboarding/logic/wizard_state.dart';

// TODO(backend): add login once the auth method is known.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WizardCubit, WizardState>(
          builder: (context, state) {
            if (!state.isLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 48),
                Text(
                  l10n.welcomeTitle,
                  style: textTheme.headlineMedium,
                  // Announced as a heading by screen readers.
                  semanticsLabel: l10n.welcomeTitle,
                ),
                const SizedBox(height: 16),
                Text(l10n.welcomeBody, style: textTheme.bodyLarge),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => context.go(state.step.path),
                  child: Text(
                    state.hasSavedDraft
                        ? l10n.continueApplication
                        : l10n.startApplication,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
