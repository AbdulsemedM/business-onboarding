import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../core/utils/phone_validation.dart';
import '../../l10n/app_localizations.dart';
import 'country_picker_sheet.dart';

/// Phone number text field with a country code button in front.
///
/// The number is validated against the selected country.
class PhoneFormField extends StatelessWidget {
  const PhoneFormField({
    super.key,
    required this.name,
    required this.label,
    required this.country,
    required this.onCountryChanged,
    required this.onNumberChanged,
    this.initialNumber,
  });

  final String name;
  final String label;
  final IsoCode country;
  final String? initialNumber;
  final ValueChanged<IsoCode> onCountryChanged;
  final ValueChanged<String?> onNumberChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dialCode = dialCodeFor(country);

    return FormBuilderTextField(
      name: name,
      initialValue: initialNumber,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+()\-\s]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: TextButton(
            onPressed: () async {
              final picked = await showCountryPickerSheet(context);
              if (picked != null) onCountryChanged(picked);
            },
            child: Text(
              '${flagEmoji(country)} +$dialCode',
              semanticsLabel: l10n.phoneCountryButton(country.name, dialCode),
            ),
          ),
        ),
      ),
      onChanged: onNumberChanged,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return l10n.errorRequired;
        if (!isValidPhoneNumber(value, country)) return l10n.errorPhoneInvalid;
        return null;
      },
    );
  }
}
