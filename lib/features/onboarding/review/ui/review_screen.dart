import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../documents/data/models/uploaded_document.dart';
import '../../data/models/onboarding_draft.dart';
import '../../data/models/onboarding_step.dart';
import '../../logic/wizard_cubit.dart';
import '../../step1_business/data/step1_business_data.dart';
import '../../step2_documents/data/step2_documents_data.dart';
import '../../step2_documents/ui/document_type_labels.dart';
import '../../ui/step_titles.dart';

/// Read-only summary of the whole application, one card per step, each with
/// an Edit shortcut. Submitting is done by the wizard's bottom button.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = context.select<WizardCubit, OnboardingDraft>(
      (cubit) => cubit.state.draft,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(l10n.reviewIntro, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        _SectionCard(
          step: OnboardingStep.business,
          rows: _businessRows(context, l10n, draft.business),
        ),
        _SectionCard(
          step: OnboardingStep.documents,
          rows: _documentRows(context, l10n, draft),
        ),
        _SectionCard(
          step: OnboardingStep.compliance,
          rows: _complianceRows(l10n, draft),
        ),
      ],
    );
  }

  List<_Row> _businessRows(
    BuildContext context,
    AppLocalizations l10n,
    Step1BusinessData b,
  ) {
    final locale = Localizations.localeOf(context).toString();
    final dayFormat = DateFormat.E(locale);
    final timeFormat = DateFormat.jm(locale);
    String time(int? minutes) => minutes == null
        ? '?'
        : timeFormat.format(DateTime(2000, 1, 1, minutes ~/ 60, minutes % 60));
    String? yearsMonths(int? years, int? months) =>
        years == null && months == null
        ? null
        : l10n.reviewYearsMonths(years ?? 0, months ?? 0);
    String property(PropertyStatus? p) => switch (p) {
      PropertyStatus.lease => l10n.propertyLease,
      PropertyStatus.own => l10n.propertyOwn,
      null => '',
    };
    String? landlord(String? name, String? phone) =>
        [name, phone].nonNulls.where((v) => v.isNotEmpty).join(' · ');

    final days = b.openDays
        .map((d) => dayFormat.format(DateTime(2024, 1, d)))
        .join(', ');
    final address = [
      b.addressLine1,
      b.addressLine2,
      [b.city, b.region, b.postalCode].nonNulls.join(', '),
      b.countryCode,
    ].nonNulls.where((v) => v.isNotEmpty).join('\n');
    final tax = b.taxDesignation;

    return [
      _Row(l10n.reviewOwner, b.ownerFullName),
      _Row(
        l10n.reviewHours,
        days.isEmpty
            ? null
            : l10n.reviewHoursValue(days, time(b.opensAt), time(b.closesAt)),
      ),
      _Row(l10n.reviewAddress, address),
      if (b.subtenant) _Row(l10n.reviewSubtenant, l10n.reviewYes),
      _Row(
        l10n.reviewTimeAtLocation,
        yearsMonths(b.yearsAtLocation, b.monthsAtLocation),
      ),
      _Row(l10n.step1BusinessProperty, property(b.businessProperty)),
      if (b.businessLandlordRequired)
        _Row(
          l10n.step1BusinessLandlordSection,
          landlord(b.businessLandlordName, b.businessLandlordPhoneNumber),
        ),
      _Row(l10n.step1ResidentialProperty, property(b.residentialProperty)),
      if (b.residentialLandlordRequired)
        _Row(
          l10n.step1ResidentialLandlordSection,
          landlord(b.residentialLandlordName, b.residentialLandlordPhoneNumber),
        ),
      if (b.yearsAtResidence != null || b.monthsAtResidence != null)
        _Row(
          l10n.reviewTimeAtResidence,
          yearsMonths(b.yearsAtResidence, b.monthsAtResidence),
        ),
      _Row(l10n.step1BankName, b.bankName),
      _Row(l10n.step1TaxSection, tax == null ? null : _taxTitle(l10n, tax)),
      if (tax != null)
        _Row(
          tax.taxIdKind == TaxIdKind.ssn
              ? l10n.step1SsnLabel
              : l10n.step1EinLabel,
          _maskTaxId(b.taxId),
        ),
    ];
  }

  List<_Row> _documentRows(
    BuildContext context,
    AppLocalizations l10n,
    OnboardingDraft draft,
  ) {
    final d = draft.documents;
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    String? file(UploadedDocument? doc) => doc?.fileName;
    String? bill(UploadedDocument? doc, DateTime? date) => doc == null
        ? null
        : date == null
        ? doc.fileName
        : l10n.reviewBillDated(doc.fileName, dateFormat.format(date));

    final photos = [
      d.exteriorPhoto,
      d.interiorLayoutPhoto,
      d.checkoutPhoto,
      d.additionalPhoto,
    ].nonNulls.length;

    return [
      for (final (index, partner) in d.partners.indexed) ...[
        _Row(
          index == 0
              ? l10n.step2OwnerHeading
              : l10n.step2PartnerHeading(index + 1),
          partner.idDocument == null || partner.idType == null
              ? null
              : l10n.reviewPartnerId(
                  index == 0
                      ? draft.business.ownerFullName
                      : [
                          partner.firstName,
                          partner.lastName,
                        ].nonNulls.join(' '),
                  _idTypeLabel(l10n, partner.idType!),
                ),
        ),
        if (partner.homeUtilityBillRequired)
          _Row(
            l10n.reviewHomeBill,
            bill(partner.homeUtilityBill, partner.homeUtilityBillDate),
          ),
      ],
      _Row(
        d.registrationType == null
            ? l10n.step2RegistrationSection
            : registrationLabel(l10n, d.registrationType!),
        file(d.businessRegistration),
      ),
      _Row(
        d.irsType == null ? l10n.step2IrsSection : irsLabel(l10n, d.irsType!),
        file(d.irsRegistration),
      ),
      _Row(
        d.licenseType == null
            ? l10n.step2LicenseSection
            : licenseLabel(l10n, d.licenseType!),
        file(d.license),
      ),
      _Row(
        l10n.step2BusinessBillCard,
        bill(d.businessUtilityBill, d.businessUtilityBillDate),
      ),
      _Row(
        l10n.step2PhotosSection,
        photos < 3 ? null : l10n.reviewPhotoCount(photos),
      ),
      if (d.usesTradeName) ...[
        _Row(l10n.step2TradeName, d.tradeName),
        if (d.dbaDocument != null) _Row(l10n.step2DbaCard, file(d.dbaDocument)),
      ],
      if (draft.business.subtenant)
        _Row(l10n.step2SubleaseCard, file(d.subleaseAgreement)),
    ];
  }

  List<_Row> _complianceRows(AppLocalizations l10n, OnboardingDraft draft) {
    final c = draft.compliance;
    final processors = [
      for (final p in c.processors)
        [p.firstName, p.lastName].nonNulls.join(' '),
    ].where((name) => name.isNotEmpty).join('\n');
    final officer = c.complianceOfficerIsOwner
        ? (draft.business.ownerFullName.isEmpty
              ? null
              : l10n.reviewOfficerIsOwner(draft.business.ownerFullName))
        : [
            c.complianceOfficerFirstName,
            c.complianceOfficerLastName,
          ].nonNulls.join(' ');
    return [
      _Row(l10n.step3ProcessorsSection, processors),
      _Row(l10n.step3OfficerSection, officer),
    ];
  }
}

String _taxTitle(AppLocalizations l10n, TaxDesignation tax) => switch (tax) {
  TaxDesignation.llcSoleEin => l10n.taxLlcSoleEinTitle,
  TaxDesignation.llcSoleSsn => l10n.taxLlcSoleSsnTitle,
  TaxDesignation.llcCCorp => l10n.taxLlcCCorpTitle,
  TaxDesignation.llcSCorp => l10n.taxLlcSCorpTitle,
};

String _idTypeLabel(AppLocalizations l10n, PersonalIdType type) =>
    switch (type) {
      PersonalIdType.governmentId => l10n.idTypeGovernmentId,
      PersonalIdType.driversLicense => l10n.idTypeDriversLicense,
      PersonalIdType.passport => l10n.idTypePassport,
    };

/// Shows only the last 4 digits: an SSN on screen is sensitive.
String? _maskTaxId(String? digits) {
  if (digits == null || digits.isEmpty) return null;
  final last4 = digits.length <= 4
      ? digits
      : digits.substring(digits.length - 4);
  return '•••••$last4';
}

/// One label/value line. A null or empty [value] shows as missing.
class _Row {
  const _Row(this.label, this.value);

  final String label;
  final String? value;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.step, required this.rows});

  final OnboardingStep step;
  final List<_Row> rows;

  void _edit(BuildContext context) {
    context.read<WizardCubit>().goTo(step);
    context.go(step.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = step.title(l10n);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${step.number}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _edit(context),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(
                    l10n.reviewEdit,
                    semanticsLabel: l10n.reviewEditSection(title),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (final (index, row) in rows.indexed) ...[
              if (index > 0) const Divider(height: 1),
              _RowView(row: row),
            ],
          ],
        ),
      ),
    );
  }
}

class _RowView extends StatelessWidget {
  const _RowView({required this.row});

  final _Row row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final value = row.value;
    final missing = value == null || value.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(row.label, style: theme.textTheme.bodySmall),
            const SizedBox(height: 2),
            if (missing)
              Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: colors.error),
                  const SizedBox(width: 4),
                  Text(
                    l10n.reviewMissing,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
