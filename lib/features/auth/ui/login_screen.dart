import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/router/routes.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/auth_cubit.dart';
import 'auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().login(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthCubit>().state;
    final failure = state.failure;

    return AuthScaffold(
      title: l10n.authSignInTitle,
      body: l10n.authSignInBody,
      children: [
        if (state.sessionExpired) ...[
          AuthError(
            failure: const AppFailure.unauthorized(),
            message: l10n.authSessionExpired,
          ),
          const SizedBox(height: 16),
        ],
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.authEmail),
                  validator: (v) => _isEmail(v) ? null : l10n.errorEmail,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _password,
                  label: l10n.authPassword,
                  autofillHints: const [AutofillHints.password],
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.errorRequired : null,
                ),
              ],
            ),
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: 16),
          AuthError(
            failure: failure,
            message: failure is UnauthorizedFailure
                ? l10n.authInvalidLogin
                : null,
          ),
        ],
        const SizedBox(height: 24),
        BusyButton(
          label: l10n.authSignIn,
          busy: state.busy,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.authNoAccount),
            TextButton(
              onPressed: state.busy
                  ? null
                  : () {
                      context.read<AuthCubit>().clearFailure();
                      context.go(Routes.register);
                    },
              child: Text(l10n.authCreateAccount),
            ),
          ],
        ),
      ],
    );
  }
}

bool _isEmail(String? value) =>
    value != null &&
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
