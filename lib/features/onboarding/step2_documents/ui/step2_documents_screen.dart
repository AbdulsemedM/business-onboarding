import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/name_form_field.dart';
import '../../../../shared/widgets/radio_group_form_field.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../documents/data/models/document_source.dart';
import '../../../documents/ui/document_form_field.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../documents/data/document_repository.dart';
import '../../../documents/data/models/document_error.dart';
import '../../data/application_repository.dart';
import '../../logic/step_validation.dart';
import '../../logic/wizard_cubit.dart';
import '../../logic/wizard_state.dart';
import '../data/step2_documents_data.dart';
import '../logic/bill_date_rules.dart';
import 'document_type_labels.dart';
import 'step2_fields.dart';
import 'widgets/bill_date_field.dart';
import 'widgets/partner_documents_section.dart';

const _photoSources = [DocumentSource.camera, DocumentSource.gallery];

/// What the Step 2 screen rebuilds on.
typedef _Step2View = ({
  Step2DocumentsData documents,
  bool subtenant,
  String ownerName,
});

class Step2DocumentsScreen extends StatefulWidget {
  const Step2DocumentsScreen({super.key});

  @override
  State<Step2DocumentsScreen> createState() => _Step2DocumentsScreenState();
}

class _Step2DocumentsScreenState extends State<Step2DocumentsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final StepValidation _validation = context.read<StepValidation>();

  /// Set by the first Next on this step.
  bool _showErrors = false;

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

  void _update(Step2DocumentsData Function(Step2DocumentsData data) change) {
    context.read<WizardCubit>().updateDraft(
      (draft) => draft.copyWith(documents: change(draft.documents)),
    );
  }

  void _updatePartner(
    String id,
    PartnerDocuments Function(PartnerDocuments partner) change,
  ) => _update((d) => d.withPartnerUpdated(id, change));

  WizardCubit get _wizard => context.read<WizardCubit>();
  ApplicationRepository get _repository =>
      context.read<ApplicationRepository>();

  /// Server owner id for a partner, creating it on the server if needed.
  /// The first partner is the Step 1 owner.
  Future<String> _ownerIdFor(String partnerId, AppLocalizations l10n) async {
    final draft = _wizard.state.draft;
    final partners = draft.documents.partners;
    final index = partners.indexWhere((p) => p.id == partnerId);
    if (index <= 0) {
      final saved = draft.primaryOwnerId;
      if (saved != null) return saved;
      final id = await _repository.saveBusinessDetails(draft.business);
      _wizard.updateDraft((d) => d.copyWith(primaryOwnerId: id));
      return id;
    }
    final partner = partners[index];
    if (partner.ownerId case final id?) return id;
    if (partner.firstName == null || partner.lastName == null) {
      throw DocumentError.needsInfo(l10n.docNeedsPartnerName);
    }
    final id = await _repository.savePartner(
      firstName: partner.firstName,
      lastName: partner.lastName,
    );
    _updatePartner(partnerId, (p) => p.copyWith(ownerId: id));
    return id;
  }

  PartnerDocuments? _partner(String id) => _wizard
      .state
      .draft
      .documents
      .partners
      .where((p) => p.id == id)
      .firstOrNull;

  Future<UploadOptions> _idOptions(
    String partnerId,
    AppLocalizations l10n,
  ) async => UploadOptions(
    businessOwnerId: await _ownerIdFor(partnerId, l10n),
    identificationListsPoBox: _partner(partnerId)?.idShowsPoBox ?? false,
  );

  Future<UploadOptions> _homeBillOptions(
    String partnerId,
    AppLocalizations l10n,
  ) async {
    final date = _partner(partnerId)?.homeUtilityBillDate;
    if (date == null) throw DocumentError.needsInfo(l10n.docNeedsBillDate);
    return UploadOptions(
      businessOwnerId: await _ownerIdFor(partnerId, l10n),
      documentDate: date,
    );
  }

  Future<UploadOptions> _businessBillOptions(AppLocalizations l10n) async {
    final date = _wizard.state.draft.documents.businessUtilityBillDate;
    if (date == null) throw DocumentError.needsInfo(l10n.docNeedsBillDate);
    return UploadOptions(documentDate: date);
  }

  /// Removes the partner here and, if they were saved, on the server.
  Future<void> _removePartner(PartnerDocuments partner) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ownerId = partner.ownerId;
    if (ownerId != null) {
      try {
        await _repository.removePartner(ownerId);
      } on AppFailure catch (failure) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.partnerRemoveFailed(failure.message(l10n))),
          ),
        );
        return;
      }
    }
    _update((d) => d.withPartnerRemoved(partner.id));
  }

  void _addPartner() => _update(
    (d) =>
        d.withPartnerAdded('partner-${DateTime.now().microsecondsSinceEpoch}'),
  );

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
      child: BlocSelector<WizardCubit, WizardState, _Step2View>(
        selector: (state) => (
          documents: state.draft.documents,
          subtenant: state.draft.business.subtenant,
          ownerName: state.draft.business.ownerFullName,
        ),
        // Not a ListView: that only builds what is on screen, and fields
        // that aren't built are skipped by validation.
        builder: (context, selected) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.step2Intro),
              ..._idSection(l10n, selected.documents, selected.ownerName),
              ..._businessDocuments(l10n, selected.documents),
              ..._photos(l10n, selected.documents),
              ..._tradeNameAndSublease(
                l10n,
                selected.documents,
                subtenant: selected.subtenant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _idSection(
    AppLocalizations l10n,
    Step2DocumentsData data,
    String ownerName,
  ) => [
    SectionHeader(l10n.step2IdSection),
    Text(l10n.step2IdHelp),
    for (final (index, partner) in data.partners.indexed)
      PartnerDocumentsSection(
        partner: partner,
        number: index + 1,
        ownerName: index == 0 ? ownerName : null,
        onChanged: (change) => _updatePartner(partner.id, change),
        idUploadOptions: () => _idOptions(partner.id, l10n),
        homeBillUploadOptions: () => _homeBillOptions(partner.id, l10n),
        onRemove: index == 0 ? null : () => _removePartner(partner),
      ),
    const SizedBox(height: 8),
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: OutlinedButton.icon(
        onPressed: _addPartner,
        icon: const Icon(Icons.person_add_alt),
        label: Text(l10n.step2AddPartner),
      ),
    ),
  ];

  List<Widget> _businessDocuments(
    AppLocalizations l10n,
    Step2DocumentsData data,
  ) {
    final required = l10n.docErrorRequired;
    final registrationType = data.registrationType;
    final irsType = data.irsType;
    final licenseType = data.licenseType;
    // For each of these the user picks the document type first, because the
    // backend needs it for the upload. Changing the type keeps the file, so
    // a mis-tap doesn't lose it; they can replace it if needed.
    // TODO(api): re-upload (or replace) when the type changes after upload.
    return [
      SectionHeader(l10n.step2RegistrationSection),
      Text(l10n.step2RegistrationHelp),
      RadioGroupFormField<RegistrationDocType>(
        key: const ValueKey(Step2Fields.registrationType),
        name: Step2Fields.registrationType,
        initialValue: registrationType,
        options: [
          for (final type in RegistrationDocType.values)
            RadioOption(value: type, title: registrationLabel(l10n, type)),
        ],
        validator: FormBuilderValidators.required(
          errorText: l10n.errorRequired,
        ),
        onChanged: (type) => _update((d) => d.copyWith(registrationType: type)),
      ),
      if (registrationType != null)
        DocumentFormField(
          name: Step2Fields.businessRegistration,
          title: registrationLabel(l10n, registrationType),
          documentType: registrationType.apiCode,
          initialDocument: data.businessRegistration,
          requiredErrorText: required,
          onChanged: (doc) =>
              _update((d) => d.copyWith(businessRegistration: doc)),
        ),

      SectionHeader(l10n.step2IrsSection),
      Text(l10n.step2IrsHelp),
      RadioGroupFormField<IrsDocType>(
        key: const ValueKey(Step2Fields.irsType),
        name: Step2Fields.irsType,
        initialValue: irsType,
        options: [
          for (final type in IrsDocType.values)
            RadioOption(value: type, title: irsLabel(l10n, type)),
        ],
        validator: FormBuilderValidators.required(
          errorText: l10n.errorRequired,
        ),
        onChanged: (type) => _update((d) => d.copyWith(irsType: type)),
      ),
      if (irsType != null)
        DocumentFormField(
          name: Step2Fields.irsRegistration,
          title: irsLabel(l10n, irsType),
          documentType: irsType.apiCode,
          initialDocument: data.irsRegistration,
          requiredErrorText: required,
          onChanged: (doc) => _update((d) => d.copyWith(irsRegistration: doc)),
        ),

      SectionHeader(l10n.step2LicenseSection),
      Text(l10n.step2LicenseHelp),
      RadioGroupFormField<LicenseCategory>(
        key: const ValueKey(Step2Fields.licenseCategory),
        name: Step2Fields.licenseCategory,
        initialValue: data.licenseCategory,
        options: _licenseOptions(l10n),
        validator: FormBuilderValidators.required(
          errorText: l10n.errorRequired,
        ),
        onChanged: (category) => _update(
          (d) => d.copyWith(
            licenseCategory: category,
            licenseType: d.licenseType?.category == category
                ? d.licenseType
                : null,
          ),
        ),
      ),
      if (data.licenseCategory case final category?) ...[
        const SizedBox(height: 8),
        // Keyed by category so it starts empty with the new list.
        FormBuilderDropdown<LicenseType>(
          key: ValueKey('${Step2Fields.licenseType}:${category.name}'),
          name: Step2Fields.licenseType,
          initialValue: licenseType?.category == category ? licenseType : null,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.step2LicenseTypeLabel),
          items: [
            for (final type in LicenseType.values)
              if (type.category == category)
                DropdownMenuItem(
                  value: type,
                  child: Text(licenseLabel(l10n, type)),
                ),
          ],
          validator: FormBuilderValidators.required(
            errorText: l10n.errorRequired,
          ),
          onChanged: (type) => _update((d) => d.copyWith(licenseType: type)),
        ),
      ],
      if (licenseType != null)
        DocumentFormField(
          name: Step2Fields.license,
          title: licenseLabel(l10n, licenseType),
          documentType: licenseType.apiCode,
          initialDocument: data.license,
          requiredErrorText: required,
          onChanged: (doc) => _update((d) => d.copyWith(license: doc)),
        ),

      SectionHeader(l10n.step2BusinessBillSection),
      DocumentFormField(
        name: Step2Fields.businessBill,
        title: l10n.step2BusinessBillCard,
        description: l10n.step2BusinessBillHelp,
        documentType: DocumentTypes.businessUtilityBill,
        initialDocument: data.businessUtilityBill,
        requiredErrorText: required,
        onChanged: (doc) =>
            _update((d) => d.copyWith(businessUtilityBill: doc)),
        uploadOptions: () => _businessBillOptions(l10n),
        details: BillDateField(
          name: Step2Fields.businessBillDate,
          window: BillWindow.last90Days,
          initialValue: data.businessUtilityBillDate,
          onChanged: (date) =>
              _update((d) => d.copyWith(businessUtilityBillDate: date)),
        ),
      ),
    ];
  }

  List<Widget> _photos(AppLocalizations l10n, Step2DocumentsData data) => [
    SectionHeader(l10n.step2PhotosSection),
    Text(l10n.step2PhotosHelp),
    DocumentFormField(
      name: Step2Fields.exteriorPhoto,
      title: l10n.photoExteriorTitle,
      description: l10n.photoExteriorHelp,
      documentType: DocumentTypes.photoExterior,
      sources: _photoSources,
      cameraHint: l10n.photoExteriorCameraHint,
      initialDocument: data.exteriorPhoto,
      requiredErrorText: l10n.docErrorRequired,
      onChanged: (doc) => _update((d) => d.copyWith(exteriorPhoto: doc)),
    ),
    DocumentFormField(
      name: Step2Fields.interiorLayoutPhoto,
      title: l10n.photoInteriorLayoutTitle,
      description: l10n.photoInteriorLayoutHelp,
      documentType: DocumentTypes.photoInteriorLayout,
      sources: _photoSources,
      initialDocument: data.interiorLayoutPhoto,
      requiredErrorText: l10n.docErrorRequired,
      onChanged: (doc) => _update((d) => d.copyWith(interiorLayoutPhoto: doc)),
    ),
    DocumentFormField(
      name: Step2Fields.checkoutPhoto,
      title: l10n.photoCheckoutTitle,
      description: l10n.photoCheckoutHelp,
      documentType: DocumentTypes.photoCheckout,
      sources: _photoSources,
      initialDocument: data.checkoutPhoto,
      requiredErrorText: l10n.docErrorRequired,
      onChanged: (doc) => _update((d) => d.copyWith(checkoutPhoto: doc)),
    ),
    DocumentFormField(
      name: Step2Fields.additionalPhoto,
      title: l10n.photoAdditionalTitle,
      description: l10n.photoAdditionalHelp,
      documentType: DocumentTypes.photoAdditional,
      sources: _photoSources,
      initialDocument: data.additionalPhoto,
      onChanged: (doc) => _update((d) => d.copyWith(additionalPhoto: doc)),
    ),
  ];

  List<Widget> _tradeNameAndSublease(
    AppLocalizations l10n,
    Step2DocumentsData data, {
    required bool subtenant,
  }) => [
    SectionHeader(l10n.step2OtherSection),
    SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.step2DbaToggle),
      value: data.usesTradeName,
      onChanged: (value) => _update((d) => d.copyWith(usesTradeName: value)),
    ),
    if (data.usesTradeName) ...[
      NameFormField(
        name: Step2Fields.tradeName,
        label: l10n.step2TradeName,
        initialValue: data.tradeName,
        isPersonName: false,
        onChanged: (name) => _update((d) => d.copyWith(tradeName: name)),
      ),
      const SizedBox(height: 12),
      _InfoNote(l10n.step2DbaNote),
      DocumentFormField(
        name: Step2Fields.dbaDocument,
        title: l10n.step2DbaCard,
        description: l10n.step2DbaCardHelp,
        documentType: DocumentTypes.dbaDocumentation,
        initialDocument: data.dbaDocument,
        onChanged: (doc) => _update((d) => d.copyWith(dbaDocument: doc)),
      ),
    ],
    // The sublease question is asked in Step 1 (backend `subtenant`).
    if (subtenant)
      DocumentFormField(
        name: Step2Fields.subleaseAgreement,
        title: l10n.step2SubleaseCard,
        description: l10n.step2SubleaseHelp,
        documentType: DocumentTypes.subleaseAgreement,
        initialDocument: data.subleaseAgreement,
        requiredErrorText: l10n.docErrorRequired,
        onChanged: (doc) => _update((d) => d.copyWith(subleaseAgreement: doc)),
      ),
  ];

  List<RadioOption<LicenseCategory>> _licenseOptions(AppLocalizations l10n) => [
    RadioOption(
      value: LicenseCategory.general,
      title: l10n.licenseGeneralTitle,
    ),
    RadioOption(
      value: LicenseCategory.industry,
      title: l10n.licenseIndustryTitle,
      subtitle: l10n.licenseIndustryBody,
    ),
    RadioOption(
      value: LicenseCategory.propertySafety,
      title: l10n.licensePropertySafetyTitle,
      subtitle: l10n.licensePropertySafetyBody,
    ),
    RadioOption(
      value: LicenseCategory.transportation,
      title: l10n.licenseTransportationTitle,
      subtitle: l10n.licenseTransportationBody,
    ),
  ];
}

class _InfoNote extends StatelessWidget {
  const _InfoNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colors.onSecondaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: colors.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
