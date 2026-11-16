import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../../core/utils/phone_validation.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/country_picker_sheet.dart';
import '../../../../shared/widgets/name_form_field.dart';
import '../../../../shared/widgets/phone_form_field.dart';
import '../../../../shared/widgets/radio_group_form_field.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../logic/step_validation.dart';
import '../../logic/wizard_cubit.dart';
import '../../logic/wizard_state.dart';
import '../data/step1_business_data.dart';
import '../logic/tax_id.dart';

/// Form field names. Also used as keys in widget tests.
abstract final class Step1Fields {
  static const ownerFirstName = 'ownerFirstName';
  static const ownerLastName = 'ownerLastName';
  static const openDays = 'openDays';
  static const opensAt = 'opensAt';
  static const closesAt = 'closesAt';
  static const addressLine1 = 'addressLine1';
  static const addressLine2 = 'addressLine2';
  static const city = 'city';
  static const region = 'region';
  static const postalCode = 'postalCode';
  static const years = 'yearsAtLocation';
  static const months = 'monthsAtLocation';
  static const businessProperty = 'businessProperty';
  static const residentialProperty = 'residentialProperty';
  static const residenceYears = 'yearsAtResidence';
  static const residenceMonths = 'monthsAtResidence';
  static const businessLandlordName = 'businessLandlordName';
  static const businessLandlordPhone = 'businessLandlordPhone';
  static const residentialLandlordName = 'residentialLandlordName';
  static const residentialLandlordPhone = 'residentialLandlordPhone';
  static const bankName = 'bankName';
  static const taxDesignation = 'taxDesignation';
  static const ein = 'ein';
  static const ssn = 'ssn';
}

class Step1BusinessScreen extends StatefulWidget {
  const Step1BusinessScreen({super.key});

  @override
  State<Step1BusinessScreen> createState() => _Step1BusinessScreenState();
}

class _Step1BusinessScreenState extends State<Step1BusinessScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final StepValidation _validation = context.read<StepValidation>();

  /// Set by the first Next on this step.
  bool _showErrors = false;

  /// Snapshot of the draft when the screen opened, used for initial values.
  /// After that the form owns the values and pushes changes to the cubit.
  late final Step1BusinessData _initial = context
      .read<WizardCubit>()
      .state
      .draft
      .business;

  @override
  void initState() {
    super.initState();
    _validation.register(_validate);
  }

  @override
  void dispose() {
    _validation.unregister(_validate);
    super.dispose();
  }

  bool _validate() {
    if (!_showErrors) setState(() => _showErrors = true);
    return _formKey.currentState?.validate(
          autoScrollWhenFocusOnInvalid: true,
        ) ??
        false;
  }

  void _update(Step1BusinessData Function(Step1BusinessData data) change) {
    context.read<WizardCubit>().updateDraft(
      (draft) => draft.copyWith(business: change(draft.business)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FormBuilder(
      key: _formKey,
      // Quiet while the user fills the form in; after the first Next, errors
      // update as they type.
      autovalidateMode: _showErrors
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      // Not a ListView: that only builds what is on screen, and fields that
      // aren't built are skipped by validation.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(l10n.step1OwnerSection),
            Text(l10n.step1OwnerHelp),
            const SizedBox(height: 8),
            NameFormField(
              name: Step1Fields.ownerFirstName,
              label: l10n.step1OwnerFirstName,
              initialValue: _initial.ownerFirstName,
              onChanged: (v) => _update((d) => d.copyWith(ownerFirstName: v)),
            ),
            const SizedBox(height: 16),
            NameFormField(
              name: Step1Fields.ownerLastName,
              label: l10n.step1OwnerLastName,
              initialValue: _initial.ownerLastName,
              onChanged: (v) => _update((d) => d.copyWith(ownerLastName: v)),
            ),

            SectionHeader(l10n.step1HoursSection),
            _OpenDaysField(
              initialValue: _initial.openDays,
              onChanged: (days) => _update((d) => d.copyWith(openDays: days)),
            ),
            const SizedBox(height: 16),
            _hoursRow(l10n),

            ..._addressSection(l10n),

            SectionHeader(l10n.step1LocationSection),
            _yearsMonthsRow(
              l10n,
              yearsName: Step1Fields.years,
              monthsName: Step1Fields.months,
              initialYears: _initial.yearsAtLocation,
              initialMonths: _initial.monthsAtLocation,
              onYears: (v) => _update((d) => d.copyWith(yearsAtLocation: v)),
              onMonths: (v) => _update((d) => d.copyWith(monthsAtLocation: v)),
            ),

            SectionHeader(l10n.step1PropertySection),
            _propertyDropdown(
              l10n,
              name: Step1Fields.businessProperty,
              label: l10n.step1BusinessProperty,
              initialValue: _initial.businessProperty,
              onChanged: (v) => _update((d) => d.copyWith(businessProperty: v)),
            ),
            const SizedBox(height: 16),
            _propertyDropdown(
              l10n,
              name: Step1Fields.residentialProperty,
              label: l10n.step1ResidentialProperty,
              initialValue: _initial.residentialProperty,
              onChanged: (v) =>
                  _update((d) => d.copyWith(residentialProperty: v)),
            ),

            SectionHeader(l10n.step1ResidenceTimeSection),
            _yearsMonthsRow(
              l10n,
              yearsName: Step1Fields.residenceYears,
              monthsName: Step1Fields.residenceMonths,
              initialYears: _initial.yearsAtResidence,
              initialMonths: _initial.monthsAtResidence,
              required: false,
              onYears: (v) => _update((d) => d.copyWith(yearsAtResidence: v)),
              onMonths: (v) => _update((d) => d.copyWith(monthsAtResidence: v)),
            ),

            _businessLandlordSection(l10n),
            _residentialLandlordSection(l10n),

            SectionHeader(l10n.step1BankSection),
            FormBuilderTextField(
              name: Step1Fields.bankName,
              initialValue: _initial.bankName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.step1BankName),
              validator: FormBuilderValidators.required(
                errorText: l10n.errorRequired,
              ),
              onChanged: (v) => _update((d) => d.copyWith(bankName: v?.trim())),
            ),

            SectionHeader(l10n.step1TaxSection),
            RadioGroupFormField<TaxDesignation>(
              name: Step1Fields.taxDesignation,
              initialValue: _initial.taxDesignation,
              options: _taxOptions(l10n),
              validator: FormBuilderValidators.required(
                errorText: l10n.errorRequired,
              ),
              onChanged: (v) => _update(
                (d) => d.copyWith(
                  taxDesignation: v,
                  // An EIN is not an SSN: start over when the kind changes.
                  taxId: d.taxDesignation?.taxIdKind == v?.taxIdKind
                      ? d.taxId
                      : null,
                ),
              ),
            ),
            _taxIdField(l10n),
          ],
        ),
      ),
    );
  }

  Widget _hoursRow(AppLocalizations l10n) {
    final timeFormat = DateFormat.jm(
      Localizations.localeOf(context).toString(),
    );

    Widget picker({
      required String name,
      required String label,
      required int? initialMinutes,
      required ValueChanged<int?> onChanged,
      FormFieldValidator<DateTime>? extraValidator,
    }) {
      return FormBuilderDateTimePicker(
        name: name,
        inputType: InputType.time,
        format: timeFormat,
        initialValue: _timeFromMinutes(initialMinutes),
        initialTime: const TimeOfDay(hour: 9, minute: 0),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.schedule),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: l10n.errorRequired),
          ?extraValidator,
        ]),
        onChanged: (v) => onChanged(_minutesFromTime(v)),
      );
    }

    // Wraps to two lines when text is large so labels stay readable.
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
          child: picker(
            name: Step1Fields.opensAt,
            label: l10n.step1OpensAt,
            initialMinutes: _initial.opensAt,
            onChanged: (v) => _update((d) => d.copyWith(opensAt: v)),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
          child: picker(
            name: Step1Fields.closesAt,
            label: l10n.step1ClosesAt,
            initialMinutes: _initial.closesAt,
            onChanged: (v) => _update((d) => d.copyWith(closesAt: v)),
            // Overnight hours (e.g. 6 PM to 2 AM) are allowed; only an
            // identical open and close time is rejected.
            extraValidator: (closes) {
              final opens =
                  _formKey.currentState?.fields[Step1Fields.opensAt]?.value
                      as DateTime?;
              if (closes == null || opens == null) return null;
              return _minutesFromTime(closes) == _minutesFromTime(opens)
                  ? l10n.errorSameTimes
                  : null;
            },
          ),
        ),
      ],
    );
  }

  /// Backend requires line 1, city and country. The rest is optional.
  List<Widget> _addressSection(AppLocalizations l10n) {
    Widget text({
      required String name,
      required String label,
      required String? initialValue,
      required ValueChanged<String?> onChanged,
      bool required = false,
      Iterable<String>? autofillHints,
      int maxLength = 100,
      TextCapitalization capitalization = TextCapitalization.words,
    }) {
      return FormBuilderTextField(
        name: name,
        initialValue: initialValue,
        textCapitalization: capitalization,
        textInputAction: TextInputAction.next,
        autofillHints: autofillHints,
        inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
        decoration: InputDecoration(labelText: label),
        validator: required
            ? FormBuilderValidators.required(errorText: l10n.errorRequired)
            : null,
        onChanged: (value) {
          final trimmed = value?.trim();
          onChanged(trimmed == null || trimmed.isEmpty ? null : trimmed);
        },
      );
    }

    return [
      SectionHeader(l10n.step1AddressSection),
      text(
        name: Step1Fields.addressLine1,
        label: l10n.step1AddressLine1,
        initialValue: _initial.addressLine1,
        required: true,
        autofillHints: const [AutofillHints.streetAddressLine1],
        onChanged: (v) => _update((d) => d.copyWith(addressLine1: v)),
      ),
      const SizedBox(height: 16),
      text(
        name: Step1Fields.addressLine2,
        label: l10n.step1AddressLine2,
        initialValue: _initial.addressLine2,
        autofillHints: const [AutofillHints.streetAddressLine2],
        onChanged: (v) => _update((d) => d.copyWith(addressLine2: v)),
      ),
      const SizedBox(height: 16),
      text(
        name: Step1Fields.city,
        label: l10n.step1City,
        initialValue: _initial.city,
        required: true,
        autofillHints: const [AutofillHints.addressCity],
        onChanged: (v) => _update((d) => d.copyWith(city: v)),
      ),
      const SizedBox(height: 16),
      text(
        name: Step1Fields.region,
        label: l10n.step1Region,
        initialValue: _initial.region,
        autofillHints: const [AutofillHints.addressState],
        onChanged: (v) => _update((d) => d.copyWith(region: v)),
      ),
      const SizedBox(height: 16),
      text(
        name: Step1Fields.postalCode,
        label: l10n.step1PostalCode,
        initialValue: _initial.postalCode,
        maxLength: 20,
        capitalization: TextCapitalization.characters,
        autofillHints: const [AutofillHints.postalCode],
        onChanged: (v) => _update((d) => d.copyWith(postalCode: v)),
      ),
      const SizedBox(height: 16),
      BlocSelector<WizardCubit, WizardState, String>(
        selector: (state) => state.draft.business.countryCode,
        builder: (context, code) => _CountryField(
          countryCode: code,
          onChanged: (iso) => _update((d) => d.copyWith(countryCode: iso.name)),
        ),
      ),
      BlocSelector<WizardCubit, WizardState, bool>(
        selector: (state) => state.draft.business.subtenant,
        builder: (context, subtenant) => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.step1SubtenantToggle),
          value: subtenant,
          onChanged: (v) => _update((d) => d.copyWith(subtenant: v)),
        ),
      ),
    ];
  }

  /// Years + months. When not [required], both may be left empty, and an
  /// empty half next to a filled one counts as 0.
  Widget _yearsMonthsRow(
    AppLocalizations l10n, {
    required String yearsName,
    required String monthsName,
    required int? initialYears,
    required int? initialMonths,
    required ValueChanged<int?> onYears,
    required ValueChanged<int?> onMonths,
    bool required = true,
  }) {
    Widget numberField({
      required String name,
      required String label,
      required int? initialValue,
      required int max,
      required String rangeError,
      required ValueChanged<int?> onChanged,
    }) {
      return FormBuilderTextField(
        name: name,
        initialValue: initialValue?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return required ? l10n.errorRequired : null;
          }
          final n = int.tryParse(value);
          return n == null || n < 0 || n > max ? rangeError : null;
        },
        onChanged: (v) => onChanged(int.tryParse(v ?? '')),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: numberField(
            name: yearsName,
            label: l10n.step1Years,
            initialValue: initialYears,
            max: 99,
            rangeError: l10n.errorYearsRange,
            onChanged: onYears,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: numberField(
            name: monthsName,
            label: l10n.step1Months,
            initialValue: initialMonths,
            max: 11,
            rangeError: l10n.errorMonthsRange,
            onChanged: onMonths,
          ),
        ),
      ],
    );
  }

  Widget _propertyDropdown(
    AppLocalizations l10n, {
    required String name,
    required String label,
    required PropertyStatus? initialValue,
    required ValueChanged<PropertyStatus?> onChanged,
  }) {
    return FormBuilderDropdown<PropertyStatus>(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(
          value: PropertyStatus.lease,
          child: Text(l10n.propertyLease),
        ),
        DropdownMenuItem(
          value: PropertyStatus.own,
          child: Text(l10n.propertyOwn),
        ),
      ],
      validator: FormBuilderValidators.required(errorText: l10n.errorRequired),
      onChanged: onChanged,
    );
  }

  Widget _businessLandlordSection(AppLocalizations l10n) => _LandlordSection(
    isShown: (b) => b.businessLandlordRequired,
    title: l10n.step1BusinessLandlordSection,
    nameField: Step1Fields.businessLandlordName,
    nameLabel: l10n.step1BusinessLandlordName,
    phoneField: Step1Fields.businessLandlordPhone,
    phoneLabel: l10n.step1BusinessLandlordPhone,
    name: (b) => b.businessLandlordName,
    phoneCountry: (b) => b.businessLandlordPhoneCountry,
    phoneNumber: (b) => b.businessLandlordPhoneNumber,
    onNameChanged: (v) =>
        _update((d) => d.copyWith(businessLandlordName: v?.trim())),
    onCountryChanged: (iso) =>
        _update((d) => d.copyWith(businessLandlordPhoneCountry: iso.name)),
    onNumberChanged: (v) =>
        _update((d) => d.copyWith(businessLandlordPhoneNumber: v)),
  );

  Widget _residentialLandlordSection(AppLocalizations l10n) => _LandlordSection(
    isShown: (b) => b.residentialLandlordRequired,
    title: l10n.step1ResidentialLandlordSection,
    nameField: Step1Fields.residentialLandlordName,
    nameLabel: l10n.step1ResidentialLandlordName,
    phoneField: Step1Fields.residentialLandlordPhone,
    phoneLabel: l10n.step1ResidentialLandlordPhone,
    name: (b) => b.residentialLandlordName,
    phoneCountry: (b) => b.residentialLandlordPhoneCountry,
    phoneNumber: (b) => b.residentialLandlordPhoneNumber,
    onNameChanged: (v) =>
        _update((d) => d.copyWith(residentialLandlordName: v?.trim())),
    onCountryChanged: (iso) =>
        _update((d) => d.copyWith(residentialLandlordPhoneCountry: iso.name)),
    onNumberChanged: (v) =>
        _update((d) => d.copyWith(residentialLandlordPhoneNumber: v)),
  );

  /// EIN or the owner's SSN, depending on the tax designation. Hidden until
  /// one is picked. Each kind is its own field, so switching starts empty.
  Widget _taxIdField(AppLocalizations l10n) {
    return BlocSelector<WizardCubit, WizardState, TaxIdKind?>(
      selector: (state) => state.draft.business.taxDesignation?.taxIdKind,
      builder: (context, kind) {
        if (kind == null) return const SizedBox.shrink();
        final saved = context.read<WizardCubit>().state.draft.business.taxId;
        final (name, label, hint, error) = switch (kind) {
          TaxIdKind.ein => (
            Step1Fields.ein,
            l10n.step1EinLabel,
            'XX-XXXXXXX',
            l10n.errorEinFormat,
          ),
          TaxIdKind.ssn => (
            Step1Fields.ssn,
            l10n.step1SsnLabel,
            'XXX-XX-XXXX',
            l10n.errorSsnFormat,
          ),
        };
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: FormBuilderTextField(
            key: ValueKey('taxId:$name'),
            name: name,
            initialValue: saved == null ? null : formatTaxId(saved, kind),
            keyboardType: TextInputType.number,
            autocorrect: false,
            enableSuggestions: false,
            inputFormatters: [TaxIdInputFormatter(kind)],
            decoration: InputDecoration(labelText: label, hintText: hint),
            validator: (value) => value == null || value.isEmpty
                ? l10n.errorRequired
                : isValidTaxId(value, kind)
                ? null
                : error,
            onChanged: (v) {
              final digits = taxIdDigitsOf(v ?? '');
              _update((d) => d.copyWith(taxId: digits.isEmpty ? null : digits));
            },
          ),
        );
      },
    );
  }

  List<RadioOption<TaxDesignation>> _taxOptions(AppLocalizations l10n) => [
    RadioOption(
      value: TaxDesignation.llcSoleEin,
      title: l10n.taxLlcSoleEinTitle,
      subtitle: l10n.taxLlcSoleEinBody,
    ),
    RadioOption(
      value: TaxDesignation.llcSoleSsn,
      title: l10n.taxLlcSoleSsnTitle,
      subtitle: l10n.taxLlcSoleSsnBody,
    ),
    RadioOption(
      value: TaxDesignation.llcCCorp,
      title: l10n.taxLlcCCorpTitle,
      subtitle: l10n.taxLlcCCorpBody,
    ),
    RadioOption(
      value: TaxDesignation.llcSCorp,
      title: l10n.taxLlcSCorpTitle,
      subtitle: l10n.taxLlcSCorpBody,
    ),
  ];
}

/// Landlord name + phone, shown only while [isShown]. When hidden, the
/// fields leave the form, so they are not validated.
class _LandlordSection extends StatelessWidget {
  const _LandlordSection({
    required this.isShown,
    required this.title,
    required this.nameField,
    required this.nameLabel,
    required this.phoneField,
    required this.phoneLabel,
    required this.name,
    required this.phoneCountry,
    required this.phoneNumber,
    required this.onNameChanged,
    required this.onCountryChanged,
    required this.onNumberChanged,
  });

  final bool Function(Step1BusinessData data) isShown;
  final String title;
  final String nameField;
  final String nameLabel;
  final String phoneField;
  final String phoneLabel;
  final String? Function(Step1BusinessData data) name;
  final String Function(Step1BusinessData data) phoneCountry;
  final String? Function(Step1BusinessData data) phoneNumber;
  final ValueChanged<String?> onNameChanged;
  final ValueChanged<IsoCode> onCountryChanged;
  final ValueChanged<String?> onNumberChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocSelector<WizardCubit, WizardState, bool>(
      selector: (state) => isShown(state.draft.business),
      builder: (context, shown) {
        if (!shown) return const SizedBox.shrink();
        final business = context.read<WizardCubit>().state.draft.business;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(title),
            FormBuilderTextField(
              name: nameField,
              initialValue: name(business),
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(labelText: nameLabel),
              validator: FormBuilderValidators.required(
                errorText: l10n.errorRequired,
              ),
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 16),
            BlocSelector<WizardCubit, WizardState, String>(
              selector: (state) => phoneCountry(state.draft.business),
              builder: (context, countryCode) => PhoneFormField(
                name: phoneField,
                label: phoneLabel,
                country: isoCodeFrom(countryCode) ?? IsoCode.US,
                initialNumber: phoneNumber(business),
                onCountryChanged: onCountryChanged,
                onNumberChanged: onNumberChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Business address country. Always set (defaults to US), so no validation.
class _CountryField extends StatelessWidget {
  const _CountryField({required this.countryCode, required this.onChanged});

  final String countryCode;
  final ValueChanged<IsoCode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final iso = isoCodeFrom(countryCode) ?? IsoCode.US;
    return Semantics(
      button: true,
      label: l10n.step1CountryButton(iso.name),
      excludeSemantics: true,
      child: InkWell(
        onTap: () async {
          final picked = await showCountryPickerSheet(context);
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: l10n.step1Country,
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          child: Text('${flagEmoji(iso)} ${iso.name}'),
        ),
      ),
    );
  }
}

/// Mon-Sun filter chips. Short names on screen, full names for screen readers.
class _OpenDaysField extends StatelessWidget {
  const _OpenDaysField({required this.initialValue, required this.onChanged});

  final List<int> initialValue;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final short = DateFormat.E(locale);
    final full = DateFormat.EEEE(locale);
    // 1 Jan 2024 was a Monday, so day N of that week is ISO weekday N.
    DateTime dayFor(int weekday) => DateTime(2024, 1, weekday);

    return FormBuilderFilterChips<int>(
      name: Step1Fields.openDays,
      initialValue: initialValue,
      spacing: 8,
      runSpacing: 4,
      decoration: InputDecoration(
        labelText: l10n.step1DaysLabel,
        border: InputBorder.none,
      ),
      options: [
        for (var weekday = 1; weekday <= 7; weekday++)
          FormBuilderChipOption(
            value: weekday,
            child: Text(
              short.format(dayFor(weekday)),
              semanticsLabel: full.format(dayFor(weekday)),
            ),
          ),
      ],
      validator: (days) =>
          (days == null || days.isEmpty) ? l10n.errorSelectDay : null,
      onChanged: (days) => onChanged([...?days]..sort()),
    );
  }
}

DateTime? _timeFromMinutes(int? minutes) =>
    minutes == null ? null : DateTime(2000, 1, 1, minutes ~/ 60, minutes % 60);

int? _minutesFromTime(DateTime? time) =>
    time == null ? null : time.hour * 60 + time.minute;
