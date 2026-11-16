import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../onboarding/logic/wizard_cubit.dart';
import '../logic/auth_cubit.dart';

/// Asks, then signs out and removes every draft from the device (they hold
/// personal data). Server data is kept.
Future<void> confirmSignOut(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final auth = context.read<AuthCubit>();
  final wizard = context.read<WizardCubit>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.logout_rounded),
      title: Text(l10n.authSignOutTitle),
      content: Text(l10n.authSignOutBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.authSignOut),
        ),
      ],
    ),
  );
  if (!(confirmed ?? false)) return;
  await wizard.discardAllDrafts();
  await auth.logout();
}
