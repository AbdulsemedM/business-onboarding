import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';

part 'document_error.freezed.dart';

/// Why a document could not be added. Thrown by the picker and preparer,
/// and shown on the upload card.
@freezed
sealed class DocumentError with _$DocumentError implements Exception {
  const factory DocumentError.tooLarge({required int maxBytes}) =
      DocumentTooLarge;
  const factory DocumentError.unsupportedType() = DocumentUnsupportedType;

  /// The file is damaged or not what its extension says.
  const factory DocumentError.unreadable() = DocumentUnreadable;

  /// Camera or photo access was denied; the user must allow it in Settings.
  const factory DocumentError.permissionDenied() = DocumentPermissionDenied;
  const factory DocumentError.upload(AppFailure failure) = DocumentUploadFailed;
}
