import 'models/local_file.dart';
import 'models/uploaded_document.dart';

class UploadLimits {
  const UploadLimits({required this.maxBytes});

  final int maxBytes;
}

/// Uploads documents to the backend.
///
/// Errors are thrown as [AppFailure] (directly or inside a DioException).
// TODO(backend): implement against the real API once the upload method
// (multipart or pre-signed URL), document types, and limits are known.
abstract interface class DocumentRepository {
  Future<UploadLimits> getLimits();

  /// [documentType] identifies the slot, e.g. "business_utility_bill".
  /// [onProgress] is called with values from 0 to 1.
  Future<UploadedDocument> upload(
    LocalFile file, {
    required String documentType,
    required void Function(double progress) onProgress,
  });
}

/// Pretends to upload with simulated progress. Used until the API is wired.
class MockDocumentRepository implements DocumentRepository {
  MockDocumentRepository({
    this.limits = const UploadLimits(maxBytes: 10 * 1024 * 1024),
    this.stepDelay = const Duration(milliseconds: 120),
  });

  final UploadLimits limits;
  final Duration stepDelay;
  int _nextId = 1;

  @override
  Future<UploadLimits> getLimits() async => limits;

  @override
  Future<UploadedDocument> upload(
    LocalFile file, {
    required String documentType,
    required void Function(double progress) onProgress,
  }) async {
    const steps = 10;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(stepDelay);
      onProgress(i / steps);
    }
    return UploadedDocument(
      id: 'mock-${_nextId++}',
      fileName: file.name,
      mimeType: file.mimeType ?? 'application/octet-stream',
      sizeBytes: file.sizeBytes,
    );
  }
}
