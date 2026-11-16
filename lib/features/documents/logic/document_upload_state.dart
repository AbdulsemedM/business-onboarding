import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/document_error.dart';
import '../data/models/local_file.dart';
import '../data/models/uploaded_document.dart';

part 'document_upload_state.freezed.dart';

/// State of one upload card.
///
/// [previous] is the document already on the server while a replacement is
/// being added; it stays valid if the replacement fails.
@freezed
sealed class DocumentUploadState with _$DocumentUploadState {
  const factory DocumentUploadState.empty() = DocumentEmpty;

  /// Compressing / checking the picked file.
  const factory DocumentUploadState.preparing({UploadedDocument? previous}) =
      DocumentPreparing;

  const factory DocumentUploadState.uploading({
    required LocalFile file,
    required double progress,
    UploadedDocument? previous,
  }) = DocumentUploading;

  const factory DocumentUploadState.uploaded(UploadedDocument document) =
      DocumentUploaded;

  /// [file] is set when the upload itself failed, so it can be retried.
  const factory DocumentUploadState.failed({
    required DocumentError error,
    LocalFile? file,
    UploadedDocument? previous,
  }) = DocumentFailed;

  /// Rejected by the reviewer. [reason] comes from the server.
  const factory DocumentUploadState.rejected({
    required String reason,
    UploadedDocument? document,
  }) = DocumentRejected;
}
