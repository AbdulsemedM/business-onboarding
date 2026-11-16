import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/interceptors/error_interceptor.dart';
import '../data/document_picker.dart';
import '../data/document_repository.dart';
import '../data/file_preparer.dart';
import '../data/models/document_error.dart';
import '../data/models/document_source.dart';
import '../data/models/local_file.dart';
import '../data/models/uploaded_document.dart';
import 'document_upload_state.dart';

/// Drives one upload card: pick -> prepare -> check size -> upload.
///
/// [onChanged] is called when the server-side document changes (uploaded,
/// replaced, or removed) so the owner can store it in the draft.
class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  DocumentUploadCubit({
    required this.documentType,
    required DocumentRepository repository,
    required DocumentPicker picker,
    required FilePreparer preparer,
    UploadedDocument? initialDocument,
    String? rejectionReason,
    this.onChanged,
    this.resolveOptions,
  }) : _repository = repository,
       _picker = picker,
       _preparer = preparer,
       super(
         rejectionReason != null
             ? DocumentUploadState.rejected(
                 reason: rejectionReason,
                 document: initialDocument,
               )
             : initialDocument != null
             ? DocumentUploadState.uploaded(initialDocument)
             : const DocumentUploadState.empty(),
       );

  final String documentType;
  final DocumentRepository _repository;
  final DocumentPicker _picker;
  final FilePreparer _preparer;
  final void Function(UploadedDocument? document)? onChanged;

  /// Read right before each upload, so it sees the latest answers (bill
  /// date, partner). May throw [DocumentError.needsInfo].
  final Future<UploadOptions> Function()? resolveOptions;

  bool get isBusy => state is DocumentPreparing || state is DocumentUploading;

  /// The document currently on the server, if any.
  UploadedDocument? get _current => switch (state) {
    DocumentEmpty() => null,
    DocumentPreparing(:final previous) => previous,
    DocumentUploading(:final previous) => previous,
    DocumentUploaded(:final document) => document,
    DocumentFailed(:final previous) => previous,
    DocumentRejected(:final document) => document,
  };

  Future<void> pickAndUpload(DocumentSource source) async {
    if (isBusy) return;
    final previous = _current;

    final LocalFile? raw;
    try {
      raw = await _picker.pick(source);
    } on DocumentError catch (error) {
      _fail(error, previous: previous);
      return;
    }
    if (raw == null) return; // Cancelled: leave the card as it was.
    if (isClosed) {
      await _preparer.discard(raw);
      return;
    }

    _emit(DocumentUploadState.preparing(previous: previous));
    final LocalFile file;
    final UploadLimits limits;
    try {
      file = await _preparer.prepare(raw);
      limits = await _repository.getLimits();
    } on DocumentError catch (error) {
      _fail(error, previous: previous);
      return;
    } catch (error) {
      _fail(DocumentError.upload(failureFrom(error)), previous: previous);
      return;
    }

    if (file.sizeBytes > limits.maxBytes) {
      await _preparer.discard(file);
      _fail(
        DocumentError.tooLarge(maxBytes: limits.maxBytes),
        previous: previous,
      );
      return;
    }
    await _upload(file, previous);
  }

  Future<void> retry() async {
    final current = state;
    if (current is! DocumentFailed) return;
    final file = current.file;
    if (file == null) return;
    await _upload(file, current.previous);
  }

  /// Removes the document from this slot.
  // TODO(backend): delete on the server too, if the API supports it.
  Future<void> remove() async {
    if (isBusy) return;
    final current = state;
    if (current is DocumentFailed && current.file != null) {
      await _preparer.discard(current.file!);
    }
    _emit(const DocumentUploadState.empty());
    onChanged?.call(null);
  }

  Future<void> _upload(LocalFile file, UploadedDocument? previous) async {
    _emit(
      DocumentUploadState.uploading(
        file: file,
        progress: 0,
        previous: previous,
      ),
    );
    try {
      final options = await resolveOptions?.call() ?? const UploadOptions();
      final document = await _repository.upload(
        file,
        documentType: documentType,
        options: options,
        onProgress: (progress) => _emit(
          DocumentUploadState.uploading(
            file: file,
            progress: progress,
            previous: previous,
          ),
        ),
      );
      await _preparer.discard(file);
      _emit(DocumentUploadState.uploaded(document));
      if (!isClosed) onChanged?.call(document);
    } on DocumentError catch (error) {
      // Keep the file so Retry works once the missing info is entered.
      _fail(error, file: file, previous: previous);
    } catch (error) {
      _fail(
        DocumentError.upload(failureFrom(error)),
        file: file,
        previous: previous,
      );
    }
  }

  void _fail(
    DocumentError error, {
    LocalFile? file,
    UploadedDocument? previous,
  }) {
    _emit(
      DocumentUploadState.failed(error: error, file: file, previous: previous),
    );
  }

  void _emit(DocumentUploadState next) {
    if (!isClosed) emit(next);
  }

  @override
  Future<void> close() async {
    final current = state;
    if (current is DocumentFailed && current.file != null) {
      await _preparer.discard(current.file!);
    }
    return super.close();
  }
}
