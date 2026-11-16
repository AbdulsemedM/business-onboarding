import 'dart:async';

import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/features/documents/data/document_picker.dart';
import 'package:business_onboarding/features/documents/data/document_repository.dart';
import 'package:business_onboarding/features/documents/data/file_preparer.dart';
import 'package:business_onboarding/features/documents/data/models/document_error.dart';
import 'package:business_onboarding/features/documents/data/models/document_source.dart';
import 'package:business_onboarding/features/documents/data/models/local_file.dart';
import 'package:business_onboarding/features/documents/data/models/uploaded_document.dart';

LocalFile localFile({
  String name = 'lease.pdf',
  int sizeBytes = 2048,
  String mimeType = 'application/pdf',
}) => LocalFile(
  path: '/tmp/$name',
  name: name,
  sizeBytes: sizeBytes,
  mimeType: mimeType,
  isTemporaryCopy: true,
);

/// Returns [result] (null = user cancelled) or throws [error].
class FakeDocumentPicker implements DocumentPicker {
  LocalFile? result = localFile();
  DocumentError? error;
  final List<DocumentSource> requested = [];

  @override
  Future<LocalFile?> pick(DocumentSource source) async {
    requested.add(source);
    if (error != null) throw error!;
    return result;
  }
}

/// Passes files through unchanged, or throws [error]. Records discards.
class FakeFilePreparer implements FilePreparer {
  DocumentError? error;
  final List<LocalFile> discarded = [];

  @override
  Future<LocalFile> prepare(LocalFile raw) async {
    if (error != null) throw error!;
    return raw;
  }

  @override
  Future<void> discard(LocalFile file) async => discarded.add(file);
}

/// Reports progress 0.5 then 1, then returns a document or throws
/// [failure]. Set [failuresLeft] to fail only the first N uploads.
class FakeDocumentRepository implements DocumentRepository {
  FakeDocumentRepository({this.maxBytes = 10 * 1024 * 1024});

  final int maxBytes;
  AppFailure failure = const AppFailure.network();
  int failuresLeft = 0;
  int uploadCount = 0;

  /// When set, uploads wait for this before finishing.
  Completer<void>? gate;

  @override
  Future<UploadLimits> getLimits() async => UploadLimits(maxBytes: maxBytes);

  @override
  Future<UploadedDocument> upload(
    LocalFile file, {
    required String documentType,
    required void Function(double progress) onProgress,
  }) async {
    uploadCount++;
    onProgress(0.5);
    await gate?.future;
    if (failuresLeft > 0) {
      failuresLeft--;
      throw failure;
    }
    onProgress(1);
    return UploadedDocument(
      id: 'doc-$uploadCount',
      fileName: file.name,
      mimeType: file.mimeType ?? '',
      sizeBytes: file.sizeBytes,
    );
  }
}
