import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/interceptors/error_interceptor.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/storage/session_store.dart';
import 'models/document_error.dart';
import 'models/local_file.dart';
import 'models/uploaded_document.dart';

class UploadLimits {
  const UploadLimits({required this.maxBytes});

  final int maxBytes;
}

/// Extra details some uploads need (backend `.../uploads/initiate`).
class UploadOptions {
  const UploadOptions({
    this.businessOwnerId,
    this.documentDate,
    this.identificationListsPoBox,
  });

  /// Required for personal IDs and the home utility bill.
  final String? businessOwnerId;

  /// Statement date of a utility bill. The backend checks the window.
  final DateTime? documentDate;

  /// For personal IDs: the address on the ID is a P.O. Box.
  final bool? identificationListsPoBox;
}

/// Uploads documents to the backend.
///
/// Errors are thrown as [AppFailure] (directly or inside a DioException),
/// or as [DocumentError] (e.g. the server's size limit is lower).
abstract interface class DocumentRepository {
  Future<UploadLimits> getLimits();

  /// [documentType] is the backend document type code, e.g.
  /// `BUSINESS_UTILITY_BILL`. [onProgress] is called with values from 0 to 1.
  Future<UploadedDocument> upload(
    LocalFile file, {
    required String documentType,
    UploadOptions options,
    required void Function(double progress) onProgress,
  });
}

/// Pre-signed upload: initiate -> PUT the bytes to storage -> verify.
// TODO(api): use `.../uploads/{id}/replace` when replacing a rejected file.
class ApiDocumentRepository implements DocumentRepository {
  ApiDocumentRepository({
    required Dio api,
    required Dio uploadClient,
    required SessionStore sessionStore,
  }) : _api = api,
       _upload = uploadClient,
       _session = sessionStore;

  final Dio _api;
  final Dio _upload;
  final SessionStore _session;

  /// The backend's default. The exact limit comes back from initiate.
  static const defaultMaxBytes = 20 * 1024 * 1024;

  @override
  Future<UploadLimits> getLimits() async =>
      const UploadLimits(maxBytes: defaultMaxBytes);

  @override
  Future<UploadedDocument> upload(
    LocalFile file, {
    required String documentType,
    UploadOptions options = const UploadOptions(),
    required void Function(double progress) onProgress,
  }) async {
    final applicationId = (await _session.read())?.applicationId;
    if (applicationId == null) throw const AppFailure.unauthorized();
    final base =
        '/api/v1/partner/applications/$applicationId/onboarding/documents/uploads';
    final contentType = _contentType(file);

    try {
      final init = dataOf(
        await _api.post<dynamic>(
          '$base/initiate',
          data: {
            'documentTypeCode': documentType,
            'frontContentType': contentType,
            'frontFileSizeBytes': file.sizeBytes,
            'originalFilename': file.name,
            'businessOwnerId': ?options.businessOwnerId,
            'identificationListsPoBox': ?options.identificationListsPoBox,
            if (options.documentDate case final date?)
              'documentDate': DateFormat('yyyy-MM-dd').format(date),
          },
        ),
      );
      final max = init['maxFileSizeBytes'];
      if (max is int && file.sizeBytes > max) {
        throw DocumentError.tooLarge(maxBytes: max);
      }
      final publicId = init['documentPublicId'] as String?;
      final url = init['frontUploadUrl'] as String?;
      if (publicId == null || url == null) throw const AppFailure.server();
      onProgress(0.05);

      // The URL is signed for this content type and length: send exactly
      // those, and no auth header.
      await _upload.put<dynamic>(
        url,
        data: File(file.path).openRead(),
        options: Options(
          headers: {
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: file.sizeBytes,
          },
        ),
        onSendProgress: (sent, _) =>
            onProgress(0.05 + 0.9 * (sent / file.sizeBytes).clamp(0, 1)),
      );

      await _api.post<dynamic>('$base/$publicId/verify');
      onProgress(1);
      return UploadedDocument(
        id: publicId,
        fileName: file.name,
        mimeType: contentType,
        sizeBytes: file.sizeBytes,
      );
    } on DocumentError {
      rethrow;
    } catch (error) {
      throw failureFrom(error);
    }
  }

  static String _contentType(LocalFile file) {
    final known = file.mimeType;
    if (known != null && known.isNotEmpty) return known;
    return switch (file.extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      _ => 'application/octet-stream',
    };
  }
}

/// Pretends to upload with simulated progress. Used when no API_BASE_URL
/// is set.
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
    UploadOptions options = const UploadOptions(),
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
