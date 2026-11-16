import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../l10n/app_localizations.dart';

/// Required text field for a person's or business's name. Reports the
/// trimmed value. Keyed by [name] so it keeps its state when fields above
/// it appear or disappear.
class NameFormField extends StatelessWidget {
  NameFormField({
    required this.name,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.isPersonName = true,
    this.autofocus = false,
  }) : super(key: ValueKey('name:$name'));

  static const maxLength = 100;

  final String name;
  final String label;
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  /// Offers the device's name autofill.
  final bool isPersonName;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      autofocus: autofocus,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      autofillHints: isPersonName ? const [AutofillHints.name] : null,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      decoration: InputDecoration(labelText: label),
      validator: FormBuilderValidators.required(errorText: l10n.errorRequired),
      onChanged: (value) {
        final trimmed = value?.trim();
        onChanged(trimmed == null || trimmed.isEmpty ? null : trimmed);
      },
    );
  }
}
