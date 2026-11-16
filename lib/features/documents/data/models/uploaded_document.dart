import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_document.freezed.dart';
part 'uploaded_document.g.dart';

/// A document the server has accepted. Stored in the draft.
@freezed
abstract class UploadedDocument with _$UploadedDocument {
  const factory UploadedDocument({
    /// Server-side id.
    // TODO(backend): confirm what the upload endpoint returns.
    required String id,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
  }) = _UploadedDocument;

  factory UploadedDocument.fromJson(Map<String, dynamic> json) =>
      _$UploadedDocumentFromJson(json);
}
