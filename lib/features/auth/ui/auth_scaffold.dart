import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/brand_logo.dart';

/// Shared layout for the sign-in screens.
///
/// A navy header with the logo, title and intro sits over a white sheet that
/// holds the form. No cards or outlines. Content is capped at a comfortable reading
/// width on tablets. When [onBack] is set, a back arrow appears and the
/// phone's Back button does the same thing, so these screens are never a
/// dead end.
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

  /// At the bottom of the sheet, e.g. "Already have an account? Sign in".
  final Widget? footer;

  static const maxContentWidth = 480.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    Widget constrained(Widget child) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );

    final header = BrandBackdrop(
      child: SafeArea(
        bottom: false,
        child: constrained(
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                  child: onBack == null
                      ? null
                      : Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            onPressed: onBack,
                            tooltip: l10n.back,
                            color: AppTheme.white,
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                const BrandBadge(size: 64),
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final sheet = DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: constrained(
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...children,
                if (footer case final footer?) ...[
                  const SizedBox(height: 16),
                  footer,
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // White below the sheet, so short forms never end in a navy gap.
        backgroundColor: AppTheme.white,
        body: PopScope(
          canPop: onBack == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) onBack?.call();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                // Navy behind the sheet's rounded top corners.
                ColoredBox(color: AppTheme.secondary, child: sheet),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "New to FastPay? Create an account" at the bottom of the form.
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
