import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/group_card.dart';
import '../../../../../shared/widgets/field_row.dart';
import '../../../../../shared/widgets/name_form_field.dart';
import '../../../../../shared/widgets/radio_group_form_field.dart';
import '../../../../documents/data/document_repository.dart';
import '../../../../documents/ui/document_form_field.dart';
import '../../data/step2_documents_data.dart';
import '../../logic/bill_date_rules.dart';
import '../step2_fields.dart';
import 'bill_date_field.dart';

/// ID type, ID upload, and (for a passport or P.O. Box) a home utility bill
/// for one business partner.
class PartnerDocumentsSection extends StatelessWidget {
  PartnerDocumentsSection({
    required this.partner,
    required this.number,
    required this.onChanged,
    this.ownerName,
    this.onRemove,
    this.idUploadOptions,
    this.homeBillUploadOptions,
  }) : super(key: ValueKey('partner:${partner.id}'));

  final PartnerDocuments partner;

  /// 1-based position, for display.
  final int number;

  final void Function(PartnerDocuments Function(PartnerDocuments) change)
  onChanged;

  /// Set for the first partner: the owner's name from Step 1, shown instead
  /// of name fields.
  final String? ownerName;

  /// Null for the first partner, who can't be removed.
  final VoidCallback? onRemove;

  /// Owner id and P.O. Box flag for the ID upload, read at upload time.
  final Future<UploadOptions> Function()? idUploadOptions;

  /// Owner id and bill date for the home bill upload.
  final Future<UploadOptions> Function()? homeBillUploadOptions;

  Future<void> _confirmRemove(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.step2RemovePartner(number)),
        content: Text(l10n.step2RemovePartnerBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.step2RemoveConfirm),
          ),
        ],
      ),
    );
    if (confirmed ?? false) onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final id = partner.id;

    return GroupCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    number == 1
                        ? l10n.step2OwnerHeading
                        : l10n.step2PartnerHeading(number),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.step2RemovePartner(number),
                  onPressed: () => _confirmRemove(context),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (ownerName case final name?)
            Text(l10n.step2OwnerName(name))
          else
            FieldRow(
              children: [
                NameFormField(
                  name: Step2Fields.partnerFirstName(id),
                  label: l10n.step2PartnerFirstName,
                  initialValue: partner.firstName,
                  onChanged: (name) =>
                      onChanged((p) => p.copyWith(firstName: name)),
                ),
                NameFormField(
                  name: Step2Fields.partnerLastName(id),
                  label: l10n.step2PartnerLastName,
                  initialValue: partner.lastName,
                  onChanged: (name) =>
                      onChanged((p) => p.copyWith(lastName: name)),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Text(l10n.step2IdTypeLabel, style: theme.textTheme.labelLarge),
          RadioGroupFormField<PersonalIdType>(
            key: ValueKey(Step2Fields.idType(id)),
            name: Step2Fields.idType(id),
            initialValue: partner.idType,
            options: [
              RadioOption(
                value: PersonalIdType.governmentId,
                title: l10n.idTypeGovernmentId,
              ),
              RadioOption(
                value: PersonalIdType.driversLicense,
                title: l10n.idTypeDriversLicense,
              ),
              RadioOption(
                value: PersonalIdType.passport,
                title: l10n.idTypePassport,
                subtitle: l10n.idTypePassportNote,
              ),
            ],
            validator: FormBuilderValidators.required(
              errorText: l10n.errorRequired,
            ),
            onChanged: (type) => onChanged((p) => p.copyWith(idType: type)),
          ),
          // The backend needs the ID type for the upload, so it is picked
          // first. Changing it keeps the file.
          // TODO(api): re-upload (or replace) when the type changes after upload.
          if (partner.idType case final idType?)
            DocumentFormField(
              name: Step2Fields.idDocument(id),
              title: l10n.step2IdCard(number),
              documentType: idType.apiCode,
              initialDocument: partner.idDocument,
              requiredErrorText: l10n.docErrorRequired,
              onChanged: (doc) => onChanged((p) => p.copyWith(idDocument: doc)),
              uploadOptions: idUploadOptions,
            ),
          // A passport always needs the bill, so the question is skipped.
          if (partner.idType != PersonalIdType.passport)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.step2PoBoxToggle),
              subtitle: Text(l10n.step2PoBoxNote),
              value: partner.idShowsPoBox,
              onChanged: (value) =>
                  onChanged((p) => p.copyWith(idShowsPoBox: value)),
            ),
          if (partner.homeUtilityBillRequired)
            DocumentFormField(
              name: Step2Fields.homeBill(id),
              title: l10n.step2HomeBillCard(number),
              description: l10n.step2HomeBillHelp,
              documentType: DocumentTypes.homeUtilityBill,
              initialDocument: partner.homeUtilityBill,
              requiredErrorText: l10n.docErrorRequired,
              onChanged: (doc) =>
                  onChanged((p) => p.copyWith(homeUtilityBill: doc)),
              uploadOptions: homeBillUploadOptions,
              details: BillDateField(
                name: Step2Fields.homeBillDate(id),
                window: BillWindow.last60Days,
                initialValue: partner.homeUtilityBillDate,
                onChanged: (date) =>
                    onChanged((p) => p.copyWith(homeUtilityBillDate: date)),
              ),
            ),
        ],
      ),
    );
  }
}
