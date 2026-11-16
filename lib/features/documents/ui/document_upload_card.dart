import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/errors/failure_messages.dart';
import '../../../core/utils/file_size.dart';
import '../../../l10n/app_localizations.dart';
import '../data/document_picker.dart';
import '../data/document_repository.dart';
import '../data/file_preparer.dart';
import '../data/models/document_error.dart';
import '../data/models/document_source.dart';
import '../data/models/uploaded_document.dart';
import '../logic/document_upload_cubit.dart';
import '../logic/document_upload_state.dart';
import 'document_source_sheet.dart';

/// One required document: shows its status and lets the user add, replace,
/// retry, or remove it.
///
/// Needs [DocumentRepository], [DocumentPicker] and [FilePreparer] above it
/// in the tree.
class DocumentUploadCard extends StatelessWidget {
  const DocumentUploadCard({
    super.key,
    required this.title,
    required this.documentType,
    this.description,
    this.sources = DocumentSource.values,
    this.cameraHint,
    this.initialDocument,
    this.rejectionReason,
    this.onChanged,
    this.errorText,
    this.details,
    this.uploadOptions,
  });

  final String title;
  final String? description;

  /// Sent to the API to identify the slot.
  final String documentType;

  /// Which pickers to offer. Photos-only slots pass camera and gallery.
  final List<DocumentSource> sources;

  /// Shown before the camera opens, e.g. "Show entrance, business name,
  /// street number".
  final String? cameraHint;

  final UploadedDocument? initialDocument;

  /// Set when the reviewer rejected [initialDocument].
  final String? rejectionReason;

  /// Captured when the card is first built; later values are ignored.
  final ValueChanged<UploadedDocument?>? onChanged;

  /// Validation error from the surrounding form, e.g. "Upload this
  /// document". Outlines the card in the error color.
  final String? errorText;

  /// Extra fields that belong to this document, e.g. the bill date. Shown
  /// above the upload actions because the upload may need them first.
  final Widget? details;

  /// Extra upload details (owner, bill date), read at upload time.
  final Future<UploadOptions> Function()? uploadOptions;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentUploadCubit(
        documentType: documentType,
        repository: context.read<DocumentRepository>(),
        picker: context.read<DocumentPicker>(),
        preparer: context.read<FilePreparer>(),
        initialDocument: initialDocument,
        rejectionReason: rejectionReason,
        onChanged: onChanged,
        resolveOptions: uploadOptions,
      ),
      child: _CardView(
        title: title,
        description: description,
        sources: sources,
        cameraHint: cameraHint,
        errorText: errorText,
        details: details,
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView({
    required this.title,
    required this.description,
    required this.sources,
    required this.cameraHint,
    required this.errorText,
    required this.details,
  });

  final String title;
  final String? description;
  final List<DocumentSource> sources;
  final String? cameraHint;
  final String? errorText;
  final Widget? details;

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<DocumentUploadCubit>();
    final source = await chooseDocumentSource(
      context,
      sources: sources,
      cameraHint: cameraHint,
    );
    if (source != null) await cubit.pickAndUpload(source);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
      builder: (context, state) {
        final status = _Status.of(state);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          // Error: red outline. Uploaded: blue outline. Otherwise the
          // theme's soft border.
          shape: errorText == null && status != _Status.uploaded
              ? null
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: errorText != null
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Wraps (chip under the title) at large text sizes.
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Semantics(
                      container: true,
                      header: true,
                      child: Text(title, style: theme.textTheme.titleMedium),
                    ),
                    _StatusChip(
                      status: status,
                      label: status.label(l10n),
                      semanticsLabel: l10n.docStatusSemantics(
                        title,
                        status.label(l10n),
                      ),
                    ),
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(description!, style: theme.textTheme.bodyMedium),
                ],
                if (details != null) ...[const SizedBox(height: 16), details!],
                const SizedBox(height: 12),
                ..._body(context, state, l10n),
                if (errorText != null) ...[
                  const SizedBox(height: 12),
                  _ErrorText(errorText!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _body(
    BuildContext context,
    DocumentUploadState state,
    AppLocalizations l10n,
  ) {
    final cubit = context.read<DocumentUploadCubit>();
    final theme = Theme.of(context);

    Widget action(
      String label,
      VoidCallback onPressed, {
      bool primary = false,
    }) {
      final text = Text(label, semanticsLabel: l10n.docActionFor(label, title));
      return primary
          ? FilledButton.tonal(onPressed: onPressed, child: text)
          : OutlinedButton(onPressed: onPressed, child: text);
    }

    Widget actions(List<Widget> buttons) =>
        Wrap(spacing: 8, runSpacing: 8, children: buttons);

    return switch (state) {
      DocumentEmpty() => [
        actions([action(l10n.docAdd, () => _add(context), primary: true)]),
      ],
      DocumentPreparing() => [
        const LinearProgressIndicator(),
        const SizedBox(height: 8),
        Text(l10n.docPreparing),
      ],
      DocumentUploading(:final progress) => [
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 8),
        Text(l10n.docUploadingProgress((progress * 100).round())),
      ],
      DocumentUploaded(:final document) => [
        _FileRow(document: document),
        const SizedBox(height: 12),
        actions([
          action(l10n.docReplace, () => _add(context)),
          action(l10n.docRemove, cubit.remove),
        ]),
      ],
      DocumentFailed(:final error, :final file, :final previous) => [
        if (previous != null) ...[
          _FileRow(document: previous),
          const SizedBox(height: 4),
          Text(l10n.docCurrentFileNote, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
        ],
        _ErrorText(_errorMessage(error, l10n)),
        const SizedBox(height: 12),
        actions([
          if (file != null) action(l10n.docRetry, cubit.retry, primary: true),
          if (error is DocumentPermissionDenied)
            action(l10n.docOpenSettings, openAppSettings, primary: true),
          action(l10n.docChooseAnother, () => _add(context)),
        ]),
      ],
      DocumentRejected(:final reason, :final document) => [
        if (document != null) ...[
          _FileRow(document: document),
          const SizedBox(height: 8),
        ],
        _ErrorText(l10n.docRejectedReason(reason)),
        const SizedBox(height: 12),
        actions([action(l10n.docReplace, () => _add(context), primary: true)]),
      ],
    };
  }

  String _errorMessage(DocumentError error, AppLocalizations l10n) =>
      switch (error) {
        DocumentTooLarge(:final maxBytes) => l10n.docErrorTooLarge(
          formatFileSize(maxBytes, l10n),
        ),
        DocumentUnsupportedType() => l10n.docErrorUnsupported,
        DocumentUnreadable() => l10n.docErrorUnreadable,
        DocumentPermissionDenied() => l10n.docErrorPermission,
        DocumentNeedsInfo(:final message) => message,
        DocumentUploadFailed(:final failure) => failure.message(l10n),
      };
}

enum _Status {
  notUploaded,
  preparing,
  uploading,
  uploaded,
  failed,
  rejected;

  static _Status of(DocumentUploadState state) => switch (state) {
    DocumentEmpty() => notUploaded,
    DocumentPreparing() => preparing,
    DocumentUploading() => uploading,
    DocumentUploaded() => uploaded,
    DocumentFailed() => failed,
    DocumentRejected() => rejected,
  };

  String label(AppLocalizations l10n) => switch (this) {
    notUploaded => l10n.docStatusNotUploaded,
    preparing => l10n.docStatusPreparing,
    uploading => l10n.docStatusUploading,
    uploaded => l10n.docStatusUploaded,
    failed => l10n.docStatusFailed,
    rejected => l10n.docStatusRejected,
  };

  IconData get icon => switch (this) {
    notUploaded => Icons.upload_file,
    preparing || uploading => Icons.cloud_upload_outlined,
    uploaded => Icons.check_circle,
    failed => Icons.error_outline,
    rejected => Icons.cancel_outlined,
  };

  Color color(ColorScheme colors) => switch (this) {
    notUploaded || preparing || uploading => colors.onSurfaceVariant,
    uploaded => colors.primary,
    failed || rejected => colors.error,
  };
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.label,
    required this.semanticsLabel,
  });

  final _Status status;
  final String label;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final color = status.color(Theme.of(context).colorScheme);
    // Live region: screen readers announce status changes (e.g. "Uploaded").
    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.document});

  final UploadedDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPdf = document.mimeType == 'application/pdf';
    return Row(
      children: [
        Icon(isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            document.fileName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(formatFileSize(document.sizeBytes, l10n)),
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 20, color: colors.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: colors.error)),
        ),
      ],
    );
  }
}
