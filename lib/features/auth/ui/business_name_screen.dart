import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/name_form_field.dart';
import '../logic/auth_cubit.dart';
import 'auth_scaffold.dart';

/// Starts a new application (one per business) and opens it.
class BusinessNameScreen extends StatefulWidget {
  const BusinessNameScreen({super.key});

  @override
  State<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends State<BusinessNameScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? _name;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthCubit>();
    await auth.createApplication(_name!);
    if (!mounted || auth.state.failure != null) return;
    context.go(Routes.welcome);
  }

  void _back() {
    context.read<AuthCubit>().clearFailure();
    context.go(Routes.applications);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthCubit>().state;
    final failure = state.failure;

    return AuthScaffold(
      title: l10n.authBusinessNameTitle,
      body: l10n.authBusinessNameBody,
      onBack: state.busy ? null : _back,
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
      ],
    );
  }
}
