import 'package:flutter/material.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/brand_logo.dart';

/// Shared layout for the sign-in screens: brand logo, title, intro, form.
///
/// The form sits on a white card over a soft tinted background, and is
/// capped at a comfortable reading width on tablets. When [onBack] is set,
/// a back arrow appears and the phone's Back button does the same thing,
/// so these screens are never a dead end.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.children,
    this.onBack,
    this.footer,
  });

  final String title;
  final String body;
  final List<Widget> children;

  /// Where Back goes. No arrow and no Back handling when null.
  final VoidCallback? onBack;

  /// Pinned under the card, e.g. "Already have an account? Sign in".
  final Widget? footer;

  static const maxContentWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      body: PopScope(
        canPop: onBack == null,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) onBack?.call();
        },
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Row(
                    children: [
                      if (onBack case final onBack?)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 4),
                          child: IconButton(
                            onPressed: onBack,
                            tooltip: l10n.back,
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      const Expanded(child: BrandLogo(height: 40)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            body,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...children,
                        ],
                      ),
                    ),
                  ),
                  if (footer case final footer?) ...[
                    const SizedBox(height: 12),
                    footer,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "New to FastPay? Create an account" under the card.
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.action,
    required this.onPressed,
  });

  final String question;
  final String action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
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
