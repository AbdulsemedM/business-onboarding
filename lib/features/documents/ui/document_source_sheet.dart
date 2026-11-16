import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../data/models/document_source.dart';

/// Asks where to pick from. Skips the sheet when there is only one source.
/// If the camera is chosen and [cameraHint] is set, shows the hint first.
///
/// Returns null if the user cancelled.
Future<DocumentSource?> chooseDocumentSource(
  BuildContext context, {
  required List<DocumentSource> sources,
  String? cameraHint,
}) async {
  final source = sources.length == 1
      ? sources.single
      : await showModalBottomSheet<DocumentSource>(
          context: context,
          // Above the wizard's Back/Next bar and any snack bar, not inside
          // the step's nested navigator where they would cover it.
          useRootNavigator: true,
          useSafeArea: true,
          builder: (context) => _SourceSheet(sources: sources),
        );
  if (source == DocumentSource.camera && cameraHint != null) {
    if (!context.mounted) return null;
    final proceed = await _showCameraHint(context, cameraHint);
    if (!proceed) return null;
  }
  return source;
}

Future<bool> _showCameraHint(BuildContext context, String hint) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.photo_camera_outlined),
      title: Text(l10n.docCameraHintTitle),
      content: Text(hint),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.docOpenCamera),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _SourceSheet extends StatelessWidget {
  const _SourceSheet({required this.sources});

  final List<DocumentSource> sources;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Semantics(
            header: true,
            child: Text(
              l10n.docSourceTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        for (final source in sources)
          ListTile(
            leading: Icon(switch (source) {
              DocumentSource.camera => Icons.photo_camera_outlined,
              DocumentSource.gallery => Icons.photo_library_outlined,
              DocumentSource.files => Icons.folder_open_outlined,
            }),
            title: Text(switch (source) {
              DocumentSource.camera => l10n.docSourceCamera,
              DocumentSource.gallery => l10n.docSourceGallery,
              DocumentSource.files => l10n.docSourceFiles,
            }),
            onTap: () => Navigator.of(context).pop(source),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
