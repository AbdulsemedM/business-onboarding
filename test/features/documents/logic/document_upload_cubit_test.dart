import 'package:bloc_test/bloc_test.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/features/documents/data/models/document_error.dart';
import 'package:business_onboarding/features/documents/data/models/document_source.dart';
import 'package:business_onboarding/features/documents/data/models/uploaded_document.dart';
import 'package:business_onboarding/features/documents/logic/document_upload_cubit.dart';
import 'package:business_onboarding/features/documents/logic/document_upload_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/document_fakes.dart';

void main() {
  late FakeDocumentPicker picker;
  late FakeFilePreparer preparer;
  late FakeDocumentRepository repository;
  late List<UploadedDocument?> changes;

  const existing = UploadedDocument(
    id: 'old',
    fileName: 'old.pdf',
    mimeType: 'application/pdf',
    sizeBytes: 100,
  );

  setUp(() {
    picker = FakeDocumentPicker();
    preparer = FakeFilePreparer();
    repository = FakeDocumentRepository(maxBytes: 5000);
    changes = [];
  });

  DocumentUploadCubit build({
    UploadedDocument? initial,
    String? rejectionReason,
  }) => DocumentUploadCubit(
    documentType: 'utility_bill',
    repository: repository,
    picker: picker,
    preparer: preparer,
    initialDocument: initial,
    rejectionReason: rejectionReason,
    onChanged: changes.add,
  );

  group('initial state', () {
    test('empty without a document', () {
      expect(build().state, const DocumentUploadState.empty());
    });

    test('uploaded with a document', () {
      expect(
        build(initial: existing).state,
        const DocumentUploadState.uploaded(existing),
      );
    });

    test('rejected when a reason is given', () {
      expect(
        build(initial: existing, rejectionReason: 'Blurry').state,
        const DocumentUploadState.rejected(
          reason: 'Blurry',
          document: existing,
        ),
      );
    });
  });

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'picks, prepares, uploads with progress, and reports the document',
    build: build,
    act: (cubit) => cubit.pickAndUpload(DocumentSource.files),
    expect: () => [
      const DocumentUploadState.preparing(),
      isA<DocumentUploading>().having((s) => s.progress, 'progress', 0),
      isA<DocumentUploading>().having((s) => s.progress, 'progress', 0.5),
      isA<DocumentUploading>().having((s) => s.progress, 'progress', 1),
      isA<DocumentUploaded>().having((s) => s.document.id, 'id', 'doc-1'),
    ],
    verify: (_) {
      expect(picker.requested, [DocumentSource.files]);
      expect(changes.single?.fileName, 'lease.pdf');
      // Local copy cleaned up after upload.
      expect(preparer.discarded.single.name, 'lease.pdf');
    },
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'does nothing when the user cancels the picker',
    setUp: () => picker.result = null,
    build: build,
    act: (cubit) => cubit.pickAndUpload(DocumentSource.camera),
    expect: () => <DocumentUploadState>[],
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'shows permission denied from the picker',
    setUp: () => picker.error = const DocumentError.permissionDenied(),
    build: build,
    act: (cubit) => cubit.pickAndUpload(DocumentSource.camera),
    expect: () => [
      const DocumentUploadState.failed(error: DocumentError.permissionDenied()),
    ],
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'shows preparer errors without uploading',
    setUp: () => preparer.error = const DocumentError.unsupportedType(),
    build: build,
    act: (cubit) => cubit.pickAndUpload(DocumentSource.files),
    expect: () => [
      const DocumentUploadState.preparing(),
      const DocumentUploadState.failed(error: DocumentError.unsupportedType()),
    ],
    verify: (_) => expect(repository.uploadCount, 0),
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'rejects files over the size limit without uploading',
    setUp: () => picker.result = localFile(sizeBytes: 5001),
    build: build,
    act: (cubit) => cubit.pickAndUpload(DocumentSource.files),
    expect: () => [
      const DocumentUploadState.preparing(),
      const DocumentUploadState.failed(
        error: DocumentError.tooLarge(maxBytes: 5000),
      ),
    ],
    verify: (_) {
      expect(repository.uploadCount, 0);
      expect(preparer.discarded, hasLength(1));
    },
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'upload failure can be retried',
    setUp: () => repository.failuresLeft = 1,
    build: build,
    act: (cubit) async {
      await cubit.pickAndUpload(DocumentSource.files);
      expect(
        cubit.state,
        isA<DocumentFailed>()
            .having((s) => s.error, 'error', isA<DocumentUploadFailed>())
            .having((s) => s.file, 'file', isNotNull),
      );
      expect(changes, isEmpty);
      await cubit.retry();
    },
    verify: (cubit) {
      expect(cubit.state, isA<DocumentUploaded>());
      expect(repository.uploadCount, 2);
      expect(changes, hasLength(1));
    },
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'a failed replacement keeps the previous document',
    setUp: () {
      repository.failuresLeft = 1;
      repository.failure = const AppFailure.server(statusCode: 500);
    },
    build: () => build(initial: existing),
    act: (cubit) => cubit.pickAndUpload(DocumentSource.files),
    verify: (cubit) {
      final state = cubit.state as DocumentFailed;
      expect(state.previous, existing);
      expect(
        state.error,
        const DocumentError.upload(AppFailure.server(statusCode: 500)),
      );
      expect(changes, isEmpty);
    },
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'replacing a rejected document uploads the new one',
    build: () => build(initial: existing, rejectionReason: 'Expired'),
    act: (cubit) => cubit.pickAndUpload(DocumentSource.files),
    verify: (cubit) {
      expect(cubit.state, isA<DocumentUploaded>());
      expect(changes.single?.id, 'doc-1');
    },
  );

  blocTest<DocumentUploadCubit, DocumentUploadState>(
    'remove clears the slot and reports null',
    build: () => build(initial: existing),
    act: (cubit) => cubit.remove(),
    expect: () => [const DocumentUploadState.empty()],
    verify: (_) => expect(changes, [null]),
  );

  test('closing after a failed upload deletes the local copy', () async {
    repository.failuresLeft = 1;
    final cubit = build();
    await cubit.pickAndUpload(DocumentSource.files);
    expect(preparer.discarded, isEmpty);

    await cubit.close();
    expect(preparer.discarded, hasLength(1));
  });
}
