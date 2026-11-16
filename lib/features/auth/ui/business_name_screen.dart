import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/name_form_field.dart';
import '../logic/auth_cubit.dart';
import 'auth_scaffold.dart';
import 'sign_out.dart';

/// For an account that has no application yet: starts one.
class BusinessNameScreen extends StatefulWidget {
  const BusinessNameScreen({super.key});

  @override
  State<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? _name;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().createApplication(_name!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthCubit>().state;
    final failure = state.failure;

    return AuthScaffold(
      title: l10n.authBusinessNameTitle,
      body: l10n.authBusinessNameBody,
      children: [
        FormBuilder(
          key: _formKey,
          child: NameFormField(
            name: 'businessName',
            label: l10n.authBusinessName,
            initialValue: null,
            isPersonName: false,
            autofocus: true,
            onChanged: (v) => _name = v,
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: 16),
          AuthError(failure: failure),
        ],
        const SizedBox(height: 24),
        BusyButton(
          label: l10n.authContinue,
          busy: state.busy,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: state.busy ? null : () => confirmSignOut(context),
          child: Text(l10n.authSignOut),
        ),
      ],
    );
  }
}
