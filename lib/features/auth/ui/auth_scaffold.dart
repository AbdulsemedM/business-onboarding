import 'package:flutter/material.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Shared layout for the sign-in screens: brand mark, title, intro, form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.children,
  });

  final String title;
  final String body;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppTheme.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(l10n.appTitle, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 32),
            Semantics(
              header: true,
              child: Text(title, style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Red note under a form. Lists the server's reasons when it gave any.
class AuthError extends StatelessWidget {
  const AuthError({super.key, required this.failure, this.message});

  final AppFailure failure;

  /// Replaces the generic message, e.g. "email and password don't match".
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final failure = this.failure;
    final lines = message != null
        ? [message!]
        : failure is ValidationFailure && failure.messages.isNotEmpty
        ? failure.messages
        : [failure.message(l10n)];
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: colors.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                lines.join('\n'),
                style: TextStyle(color: colors.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary button that shows a spinner while [busy].
class BusyButton extends StatelessWidget {
  const BusyButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => busy
      ? FilledButton.icon(
          onPressed: null,
          icon: const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          label: Text(label),
        )
      : FilledButton(onPressed: onPressed, child: Text(label));
}

/// Password field with a show/hide button.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.autofillHints,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscured,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          tooltip: _obscured ? l10n.authShowPassword : l10n.authHidePassword,
          icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
      validator: widget.validator,
    );
  }
}
