import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../data/models/document_source.dart';
import '../data/models/uploaded_document.dart';
import 'document_upload_card.dart';

/// A [DocumentUploadCard] that takes part in a [FormBuilder], so a missing
/// document blocks "Next" like any other required field.
///
/// Keyed by [name]: when cards appear or disappear above it, each card keeps
/// its own upload state.
class DocumentFormField extends StatelessWidget {
  DocumentFormField({
    required this.name,
    required this.title,
    required this.documentType,
    required this.initialDocument,
    required this.onChanged,
    this.requiredErrorText,
    this.description,
    this.sources = DocumentSource.values,
    this.cameraHint,
    this.footer,
  }) : super(key: ValueKey('document:$name'));

  final String name;
  final String title;
  final String? description;
  final String documentType;
  final List<DocumentSource> sources;
  final String? cameraHint;
  final UploadedDocument? initialDocument;
  final ValueChanged<UploadedDocument?> onChanged;
  final Widget? footer;

  /// Shown when no document is uploaded. Null means the document is optional.
  final String? requiredErrorText;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<UploadedDocument>(
      name: name,
      initialValue: initialDocument,
      validator: (document) => document == null ? requiredErrorText : null,
      builder: (field) => DocumentUploadCard(
        title: title,
        description: description,
        documentType: documentType,
        sources: sources,
        cameraHint: cameraHint,
        initialDocument: initialDocument,
        errorText: field.errorText,
        footer: footer,
        // The card keeps this callback for its lifetime. It only uses the
        // field state and the owner's callback, which don't change.
        onChanged: (document) {
          field.didChange(document);
          onChanged(document);
        },
      ),
    );
  }
}
