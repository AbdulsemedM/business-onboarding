import 'dart:async';

import 'package:business_onboarding/features/documents/data/document_picker.dart';
import 'package:business_onboarding/features/documents/data/document_repository.dart';
import 'package:business_onboarding/features/documents/data/file_preparer.dart';
import 'package:business_onboarding/features/documents/data/models/document_error.dart';
import 'package:business_onboarding/features/documents/data/models/document_source.dart';
import 'package:business_onboarding/features/documents/data/models/uploaded_document.dart';
import 'package:business_onboarding/features/documents/ui/document_upload_card.dart';
import 'package:business_onboarding/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/document_fakes.dart';

void main() {
  late FakeDocumentPicker picker;
  late FakeDocumentRepository repository;
  late List<UploadedDocument?> changes;

  setUp(() {
    picker = FakeDocumentPicker();
    repository = FakeDocumentRepository();
    changes = [];
  });

  Future<void> pumpCard(
    WidgetTester tester, {
    List<DocumentSource> sources = DocumentSource.values,
    String? cameraHint,
    UploadedDocument? initial,
    String? rejectionReason,
  }) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DocumentRepository>.value(value: repository),
          RepositoryProvider<DocumentPicker>.value(value: picker),
          RepositoryProvider<FilePreparer>.value(value: FakeFilePreparer()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListView(
              children: [
                DocumentUploadCard(
                  title: 'Business utility bill',
                  description: 'Dated within the last 3 months.',
                  documentType: 'business_utility_bill',
                  sources: sources,
                  cameraHint: cameraHint,
                  initialDocument: initial,
                  rejectionReason: rejectionReason,
                  onChanged: changes.add,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('add from files: shows progress, then the uploaded file', (
    tester,
  ) async {
    repository.gate = Completer<void>();
    await pumpCard(tester);
    expect(find.text('Not uploaded'), findsOneWidget);

    await tapAndSettle(tester, find.text('Add document'));
    await tester.tap(find.text('Choose a file (PDF, JPG or PNG)'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Uploading'), findsOneWidget);
    expect(find.text('Uploading 50%'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    repository.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.text('Uploaded'), findsOneWidget);
    expect(find.text('lease.pdf'), findsOneWidget);
    expect(find.text('2 KB'), findsOneWidget);
    expect(find.text('Replace'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
    expect(changes.single?.id, 'doc-1');
  });

  testWidgets('single source skips the sheet', (tester) async {
    await pumpCard(tester, sources: [DocumentSource.gallery]);

    await tapAndSettle(tester, find.text('Add document'));

    expect(picker.requested, [DocumentSource.gallery]);
    expect(find.text('Uploaded'), findsOneWidget);
  });

  testWidgets('camera hint is shown first and can be cancelled', (
    tester,
  ) async {
    const hint = 'Show entrance, business name, street number';
    await pumpCard(tester, cameraHint: hint);

    await tapAndSettle(tester, find.text('Add document'));
    await tapAndSettle(tester, find.text('Take a photo'));

    expect(find.text('Before you take the photo'), findsOneWidget);
    expect(find.text(hint), findsOneWidget);

    await tapAndSettle(tester, find.text('Cancel'));
    expect(picker.requested, isEmpty);

    await tapAndSettle(tester, find.text('Add document'));
    await tapAndSettle(tester, find.text('Take a photo'));
    await tapAndSettle(tester, find.text('Open camera'));
    expect(picker.requested, [DocumentSource.camera]);
  });

  testWidgets('upload failure shows the reason and Retry works', (
    tester,
  ) async {
    repository.failuresLeft = 1;
    await pumpCard(tester, sources: [DocumentSource.files]);

    await tapAndSettle(tester, find.text('Add document'));

    expect(find.text('Upload failed'), findsOneWidget);
    expect(
      find.text('No internet connection. Check your connection and try again.'),
      findsOneWidget,
    );

    await tapAndSettle(tester, find.text('Retry'));
    expect(find.text('Uploaded'), findsOneWidget);
  });

  testWidgets('too-large file shows the limit and no Retry', (tester) async {
    picker.result = localFile(sizeBytes: 11 * 1024 * 1024);
    await pumpCard(tester, sources: [DocumentSource.files]);

    await tapAndSettle(tester, find.text('Add document'));

    expect(
      find.text('This file is too large. The maximum size is 10 MB.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsNothing);
    expect(find.text('Choose another file'), findsOneWidget);
  });

  testWidgets('permission denied offers Open settings', (tester) async {
    picker.error = const DocumentError.permissionDenied();
    await pumpCard(tester, sources: [DocumentSource.gallery]);

    await tapAndSettle(tester, find.text('Add document'));

    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('rejected document shows the reason and can be replaced', (
    tester,
  ) async {
    await pumpCard(
      tester,
      sources: [DocumentSource.files],
      initial: const UploadedDocument(
        id: 'old',
        fileName: 'old_bill.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 3 * 1024 * 1024,
      ),
      rejectionReason: 'The bill is older than 3 months.',
    );

    expect(find.text('Rejected'), findsOneWidget);
    expect(find.text('old_bill.pdf'), findsOneWidget);
    expect(find.text('3 MB'), findsOneWidget);
    expect(
      find.text('Reason: The bill is older than 3 months.'),
      findsOneWidget,
    );

    await tapAndSettle(tester, find.text('Replace'));
    expect(find.text('Uploaded'), findsOneWidget);
    expect(find.text('lease.pdf'), findsOneWidget);
  });

  testWidgets('remove returns the card to empty', (tester) async {
    await pumpCard(
      tester,
      initial: const UploadedDocument(
        id: 'x',
        fileName: 'bill.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 1000,
      ),
    );

    await tapAndSettle(tester, find.text('Remove'));

    expect(find.text('Not uploaded'), findsOneWidget);
    expect(changes, [null]);
  });

  testWidgets('status and buttons are labelled for screen readers', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpCard(tester);

    expect(
      find.bySemanticsLabel('Business utility bill: Not uploaded'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Add document: Business utility bill'),
      findsOneWidget,
    );
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });
}
