import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../documents/ui/document_upload_card.dart';
import '../../data/application_repository.dart';
import '../../data/models/application_status.dart';
import '../../data/models/onboarding_step.dart';
import '../../logic/wizard_cubit.dart';
import '../../ui/step_titles.dart';
import '../logic/status_cubit.dart';

/// Review status after submitting. When the reviewer asks for changes, only
/// the rejected documents can be uploaded again, and field fixes link back
/// into the wizard.
class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key, this.initial});

  /// Set right after a submit, so the screen shows it without reloading.
  final ApplicationSnapshot? initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = StatusCubit(
          repository: context.read<ApplicationRepository>(),
          initial: initial,
        );
        if (initial == null) cubit.load();
        return cubit;
      },
      child: const _StatusView(),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statusTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.statusRefresh,
            onPressed: () => context.read<StatusCubit>().load(),
          ),
        ],
      ),
      body: BlocBuilder<StatusCubit, StatusState>(
        builder: (context, state) => switch (state) {
          StatusLoading() => const Center(child: CircularProgressIndicator()),
          StatusFailed(:final failure) => _LoadError(
            message: failure.message(l10n),
          ),
          final StatusLoaded loaded => _Loaded(state: loaded),
        },
      ),
      bottomNavigationBar: BlocBuilder<StatusCubit, StatusState>(
        builder: (context, state) =>
            state is StatusLoaded &&
                state.snapshot.status == ApplicationStatus.actionRequired &&
                state.documentCorrections.isNotEmpty &&
                state.fieldCorrections.isEmpty
            ? _ResubmitBar(state: state)
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final StatusLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snapshot = state.snapshot;
    final docs = state.documentCorrections;
    final fields = state.fieldCorrections;
    final needsAction = snapshot.status == ApplicationStatus.actionRequired;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _StatusBanner(snapshot: snapshot),
        if (snapshot.status == ApplicationStatus.draft ||
            snapshot.status == ApplicationStatus.inProgress) ...[
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _openStep(context, null),
            child: Text(l10n.statusContinue),
          ),
        ],
        if (needsAction && docs.isNotEmpty) ...[
          SectionHeader(l10n.statusDocsSection),
          Text(
            l10n.statusDocsHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          for (final correction in docs)
            DocumentUploadCard(
              key: ValueKey('correction:${correction.id}'),
              title: correction.label,
              documentType: correction.documentType!,
              rejectionReason: correction.reason,
              // TODO(api): use the replace endpoint for the rejected
              // submission, and update the matching draft field.
              onChanged: (document) => context
                  .read<StatusCubit>()
                  .markReuploaded(correction.id, uploaded: document != null),
            ),
        ],
        if (needsAction && fields.isNotEmpty) ...[
          SectionHeader(l10n.statusFieldsSection),
          Text(
            l10n.statusFieldsHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          for (final correction in fields)
            _FieldCorrectionCard(correction: correction),
        ],
      ],
    );
  }
}

/// Opens the wizard on [step], or on the saved step when null.
void _openStep(BuildContext context, OnboardingStep? step) {
  final wizard = context.read<WizardCubit>();
  final target = step ?? wizard.state.step;
  wizard.goTo(target);
  context.go(target.path);
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.snapshot});

  final ApplicationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final status = snapshot.status;

    final (icon, color, label, headline, body) = switch (status) {
      ApplicationStatus.draft || ApplicationStatus.inProgress => (
        Icons.edit_note_rounded,
        colors.onSurfaceVariant,
        l10n.statusLabelDraft,
        l10n.statusHeadlineDraft,
        l10n.statusBodyDraft,
      ),
      ApplicationStatus.submitted || ApplicationStatus.resubmitted => (
        Icons.hourglass_top_rounded,
        colors.primary,
        l10n.statusLabelInReview,
        l10n.statusHeadlineInReview,
        l10n.statusBodyInReview,
      ),
      ApplicationStatus.actionRequired => (
        Icons.assignment_late_outlined,
        const Color(0xFFB45309),
        l10n.statusLabelActionRequired,
        l10n.statusHeadlineActionRequired,
        l10n.statusBodyActionRequired,
      ),
      ApplicationStatus.approved => (
        Icons.verified_rounded,
        const Color(0xFF15803D),
        l10n.statusLabelApproved,
        l10n.statusHeadlineApproved,
        l10n.statusBodyApproved,
      ),
      ApplicationStatus.rejected => (
        Icons.cancel_outlined,
        colors.error,
        l10n.statusLabelRejected,
        l10n.statusHeadlineRejected,
        l10n.statusBodyRejected,
      ),
    };

    final number = snapshot.applicationNumber;
    final submittedAt = snapshot.submittedAt;
    final meta = [
      if (number != null) l10n.statusAppNumber(number),
      if (submittedAt != null)
        l10n.statusSubmittedOn(
          DateFormat.yMMMd(
            Localizations.localeOf(context).toString(),
          ).format(submittedAt),
        ),
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(headline, style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyMedium),
          if (meta.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(meta, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _FieldCorrectionCard extends StatelessWidget {
  const _FieldCorrectionCard({required this.correction});

  final CorrectionItem correction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final step = correction.step ?? OnboardingStep.business;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(correction.label, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(correction.reason)),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: () => _openStep(context, step),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.statusFixIn(step.title(l10n))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResubmitBar extends StatelessWidget {
  const _ResubmitBar({required this.state});

  final StatusLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final failure = state.resubmitFailure;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (failure != null || !state.canResubmit) ...[
                Text(
                  failure?.message(l10n) ?? l10n.statusResubmitBlocked,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: failure != null ? colors.error : null,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              state.isResubmitting
                  ? FilledButton.icon(
                      onPressed: null,
                      icon: const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      label: Text(l10n.submitting),
                    )
                  : FilledButton(
                      onPressed: state.canResubmit
                          ? () => context.read<StatusCubit>().resubmit()
                          : null,
                      child: Text(l10n.statusResubmit),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<StatusCubit>().load(),
              child: Text(l10n.statusRetry),
            ),
          ],
        ),
      ),
    );
  }
}
