import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../core/router/routes.dart';
import '../../../core/utils/phone_validation.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/name_form_field.dart';
import '../../../shared/widgets/phone_form_field.dart';
import '../data/auth_repository.dart';
import '../logic/auth_cubit.dart';
import 'auth_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  IsoCode _country = IsoCode.US;

  // Name fields report trimmed values here.
  String? _first;
  String? _last;
  String? _business;
  String? _phone;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _formKey.currentState!.fields['email']!.value as String;
    context.read<AuthCubit>().register(
      RegistrationForm(
        firstName: _first!,
        lastName: _last!,
        email: email.trim(),
        phoneNumber: toE164(_phone ?? '', _country) ?? _phone ?? '',
        password: _password.text,
        businessName: _business!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthCubit>().state;
    final failure = state.failure;
    const gap = SizedBox(height: 16);

    return AuthScaffold(
      title: l10n.authRegisterTitle,
      body: l10n.authRegisterBody,
      children: [
        FormBuilder(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NameFormField(
                  name: 'firstName',
                  label: l10n.authFirstName,
                  initialValue: null,
                  onChanged: (v) => _first = v,
                ),
                gap,
                NameFormField(
                  name: 'lastName',
                  label: l10n.authLastName,
                  initialValue: null,
                  onChanged: (v) => _last = v,
                ),
                gap,
                NameFormField(
                  name: 'businessName',
                  label: l10n.authBusinessName,
                  initialValue: null,
                  isPersonName: false,
                  onChanged: (v) => _business = v,
                ),
                gap,
                FormBuilderTextField(
                  name: 'email',
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.authEmail),
                  validator: (v) =>
                      v != null &&
                          RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(v.trim())
                      ? null
                      : l10n.errorEmail,
                ),
                gap,
                PhoneFormField(
                  name: 'phone',
                  label: l10n.authPhone,
                  country: _country,
                  onCountryChanged: (iso) => setState(() => _country = iso),
                  onNumberChanged: (v) => _phone = v,
                ),
                gap,
                PasswordField(
                  controller: _password,
                  label: l10n.authPassword,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      _strongPassword(v) ? null : l10n.errorPasswordRule,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
                  child: Text(
                    l10n.authPasswordRule,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                gap,
                PasswordField(
                  controller: _confirm,
                  label: l10n.authConfirmPassword,
                  autofillHints: const [AutofillHints.newPassword],
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      v == _password.text ? null : l10n.errorPasswordMatch,
                ),
              ],
            ),
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: 16),
          AuthError(failure: failure),
        ],
        const SizedBox(height: 24),
        BusyButton(
          label: l10n.authRegister,
          busy: state.busy,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.authHaveAccount),
            TextButton(
              onPressed: state.busy
                  ? null
                  : () {
                      context.read<AuthCubit>().clearFailure();
                      context.go(Routes.login);
                    },
              child: Text(l10n.authSignIn),
            ),
          ],
        ),
      ],
    );
  }
}

/// Matches the backend's sample password policy ("SecurePass123!").
// TODO(backend): confirm the exact password policy.
bool _strongPassword(String? v) =>
    v != null &&
    v.length >= 8 &&
    RegExp('[A-Z]').hasMatch(v) &&
    RegExp('[a-z]').hasMatch(v) &&
    RegExp(r'\d').hasMatch(v) &&
    RegExp(r'[^A-Za-z0-9]').hasMatch(v);
