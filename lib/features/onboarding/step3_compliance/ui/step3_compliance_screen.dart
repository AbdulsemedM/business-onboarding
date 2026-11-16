import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/name_form_field.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../logic/step_validation.dart';
import '../../logic/wizard_cubit.dart';
import '../../logic/wizard_state.dart';
import '../data/step3_compliance_data.dart';

/// Form field names. Also used as keys in widget tests.
abstract final class Step3Fields {
  static String processorFirstName(String id) => 'processor.$id.firstName';
  static String processorLastName(String id) => 'processor.$id.lastName';
  static const officerFirstName = 'complianceOfficerFirstName';
  static const officerLastName = 'complianceOfficerLastName';
}

class Step3ComplianceScreen extends StatefulWidget {
  const Step3ComplianceScreen({super.key});

  @override
  State<Step3ComplianceScreen> createState() => _Step3ComplianceScreenState();
}

class _Step3ComplianceScreenState extends State<Step3ComplianceScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final StepValidation _validation = context.read<StepValidation>();

  /// The processor just added with the button, so its field gets focus.
  String? _addedProcessorId;

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

  bool _validate() =>
      _formKey.currentState?.validate(autoScrollWhenFocusOnInvalid: true) ??
      false;

  void _update(Step3ComplianceData Function(Step3ComplianceData data) change) {
    context.read<WizardCubit>().updateDraft(
      (draft) => draft.copyWith(compliance: change(draft.compliance)),
    );
  }

  void _addProcessor() {
    final id = 'processor-${DateTime.now().microsecondsSinceEpoch}';
    setState(() => _addedProcessorId = id);
    _update((d) => d.withProcessorAdded(id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child:
          BlocSelector<WizardCubit, WizardState, (Step3ComplianceData, String)>(
            selector: (state) =>
                (state.draft.compliance, state.draft.business.ownerFullName),
            // Not a ListView: that only builds what is on screen, and
            // fields that aren't built are skipped by validation.
            builder: (context, selected) {
              final (data, ownerName) = selected;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._processors(l10n, data),
                    ..._complianceOfficer(l10n, data, ownerName),
                  ],
                ),
              );
            },
          ),
    );
  }

  List<Widget> _processors(AppLocalizations l10n, Step3ComplianceData data) {
    final canRemove = data.processors.length > 1;
    return [
      SectionHeader(l10n.step3ProcessorsSection),
      Text(l10n.step3ProcessorsHelp),
      const SizedBox(height: 8),
      for (final (index, processor) in data.processors.indexed)
        Column(
          key: ValueKey(processor.id),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.step3ProcessorHeading(index + 1),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
                if (canRemove)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: l10n.step3RemoveProcessor(index + 1),
                    onPressed: () =>
                        _update((d) => d.withProcessorRemoved(processor.id)),
                  ),
              ],
            ),
            NameFormField(
              name: Step3Fields.processorFirstName(processor.id),
              label: l10n.firstName,
              initialValue: processor.firstName,
              autofocus: processor.id == _addedProcessorId,
              onChanged: (name) => _update(
                (d) => d.withProcessorUpdated(
                  processor.id,
                  (p) => p.copyWith(firstName: name),
                ),
              ),
            ),
            const SizedBox(height: 16),
            NameFormField(
              name: Step3Fields.processorLastName(processor.id),
              label: l10n.lastName,
              initialValue: processor.lastName,
              onChanged: (name) => _update(
                (d) => d.withProcessorUpdated(
                  processor.id,
                  (p) => p.copyWith(lastName: name),
                ),
              ),
            ),
          ],
        ),
      const SizedBox(height: 12),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton.icon(
          onPressed: _addProcessor,
          icon: const Icon(Icons.person_add_alt),
          label: Text(l10n.step3AddProcessor),
        ),
      ),
    ];
  }

  List<Widget> _complianceOfficer(
    AppLocalizations l10n,
    Step3ComplianceData data,
    String ownerName,
  ) => [
    SectionHeader(l10n.step3OfficerSection),
    Text(l10n.step3OfficerHelp),
    SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.step3OfficerSameAsOwner),
      subtitle: Text(
        ownerName.isEmpty
            ? l10n.step3OfficerOwnerUnknown
            : l10n.step3OfficerOwnerName(ownerName),
      ),
      value: data.complianceOfficerIsOwner,
      onChanged: (value) =>
          _update((d) => d.copyWith(complianceOfficerIsOwner: value)),
    ),
    if (!data.complianceOfficerIsOwner) ...[
      NameFormField(
        name: Step3Fields.officerFirstName,
        label: l10n.step3OfficerFirstName,
        initialValue: data.complianceOfficerFirstName,
        onChanged: (name) =>
            _update((d) => d.copyWith(complianceOfficerFirstName: name)),
      ),
      const SizedBox(height: 16),
      NameFormField(
        name: Step3Fields.officerLastName,
        label: l10n.step3OfficerLastName,
        initialValue: data.complianceOfficerLastName,
        onChanged: (name) =>
            _update((d) => d.copyWith(complianceOfficerLastName: name)),
      ),
    ],
  ];
}
