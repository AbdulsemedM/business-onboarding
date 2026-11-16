import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../auth/ui/auth_scaffold.dart';
import '../../auth/ui/sign_out.dart';
import '../../onboarding/data/models/application_status.dart';
import '../../onboarding/logic/wizard_cubit.dart';
import '../data/application_summary.dart';
import '../logic/applications_cubit.dart';

/// Home after sign-in: every application on the account, newest first.
/// Tap one to open it, or start a new one for another business.
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  static const maxContentWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => ApplicationsCubit(
        repository: context.read<AuthRepository>(),
        onLoaded: context.read<WizardCubit>().retainDrafts,
      )..load(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.applicationsTitle),
          actions: [
            IconButton(
              tooltip: l10n.authSignOut,
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => confirmSignOut(context),
            ),
          ],
        ),
        body: const _Body(),
        bottomNavigationBar: SafeArea(
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              // Full width (up to the cap), like the other main buttons.
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: FilledButton.icon(
                    onPressed: () => context.go(Routes.businessName),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.applicationsNew),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<ApplicationsCubit>().state;
    final failure = state.failure;

    if (state.items.isEmpty) {
      if (state.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (failure != null) {
        return _Message(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthError(failure: failure),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: context.read<ApplicationsCubit>().load,
                child: Text(l10n.statusRetry),
              ),
            ],
          ),
        );
      }
      return const _Empty();
    }

    return RefreshIndicator(
      onRefresh: context.read<ApplicationsCubit>().load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          if (failure != null) ...[
            AuthError(failure: failure),
            const SizedBox(height: 12),
          ],
          for (final app in state.items)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: ApplicationsScreen.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ApplicationCard(app: app),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.app});

  final ApplicationSummary app;

  Future<void> _open(BuildContext context) async {
    await context.read<AuthCubit>().selectApplication(app.id);
    if (!context.mounted) return;
    context.go(app.isSubmitted ? Routes.status : Routes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final number = app.applicationNumber;
    return Semantics(
      button: true,
      onTapHint: l10n.applicationsOpenHint,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.businessName, style: theme.textTheme.titleSmall),
                      if (number != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.statusAppNumber(number),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 8),
                      _StatusChip(status: app.status),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ExcludeSemantics(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ApplicationStatus? status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      ApplicationStatus.draft ||
      ApplicationStatus.inProgress ||
      null => (l10n.statusLabelDraft, colors.onSurfaceVariant),
      ApplicationStatus.submitted || ApplicationStatus.resubmitted => (
        l10n.statusLabelInReview,
        colors.secondary,
      ),
      ApplicationStatus.actionRequired => (
        l10n.statusLabelActionRequired,
        const Color(0xFFB45309),
      ),
      ApplicationStatus.approved => (
        l10n.statusLabelApproved,
        const Color(0xFF15803D),
      ),
      ApplicationStatus.rejected => (l10n.statusLabelRejected, colors.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _Message(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_rounded,
              size: 36,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.applicationsEmptyTitle,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.applicationsEmptyBody,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Centered, scrollable content for the empty and error states.
class _Message extends StatelessWidget {
  const _Message({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: child,
      ),
    ),
  );
}
