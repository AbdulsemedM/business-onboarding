import 'dart:io';

import 'package:business_onboarding/features/documents/data/file_preparer.dart';
import 'package:business_onboarding/features/documents/data/models/document_error.dart';
import 'package:business_onboarding/features/documents/data/models/local_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late Directory workDir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('preparer_test');
    workDir = await Directory('${dir.path}/work').create();
  });

  tearDown(() => dir.delete(recursive: true));

  Future<LocalFile> writeFile(
    String name,
    List<int> bytes, {
    bool temporary = false,
  }) async {
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return LocalFile(
      path: file.path,
      name: name,
      sizeBytes: bytes.length,
      isTemporaryCopy: temporary,
    );
  }

  /// Fake compressor: copies the source and adds 10 bytes.
  Future<String?> copyCompressor(String source, String target) async {
    final bytes = await File(source).readAsBytes();
    await File(target).writeAsBytes([...bytes, ...List.filled(10, 0)]);
    return target;
  }

  group('PDF', () {
    test('accepts a real PDF unchanged', () async {
      final raw = await writeFile('lease.PDF', '%PDF-1.7 rest'.codeUnits);
      final prepared = await FilePreparer(workDir: workDir).prepare(raw);

      expect(prepared.path, raw.path);
      expect(prepared.mimeType, 'application/pdf');
      expect(prepared.sizeBytes, raw.sizeBytes);
    });

    test('rejects a file that only claims to be a PDF', () async {
      final raw = await writeFile('fake.pdf', 'hello world'.codeUnits);
      expect(
        () => FilePreparer(workDir: workDir).prepare(raw),
        throwsA(isA<DocumentUnreadable>()),
      );
    });
  });

  group('images', () {
    test('compresses to JPEG and deletes the picker copy', () async {
      final raw = await writeFile('IMG_1.HEIC', [1, 2, 3], temporary: true);
      final preparer = FilePreparer(compress: copyCompressor, workDir: workDir);

      final prepared = await preparer.prepare(raw);

      expect(prepared.name, 'IMG_1.jpg');
      expect(prepared.mimeType, 'image/jpeg');
      expect(prepared.sizeBytes, 13);
      expect(prepared.isTemporaryCopy, isTrue);
      expect(prepared.path, startsWith(workDir.path));
      expect(File(raw.path).existsSync(), isFalse);
    });

    test("keeps the user's original file if it is not our copy", () async {
      final raw = await writeFile('photo.png', [1, 2, 3]);
      await FilePreparer(
        compress: copyCompressor,
        workDir: workDir,
      ).prepare(raw);
      expect(File(raw.path).existsSync(), isTrue);
    });

    test('reports unreadable when compression fails', () async {
      final raw = await writeFile('broken.jpg', [0]);
      final preparer = FilePreparer(
        compress: (_, _) async => null,
        workDir: workDir,
      );
      expect(() => preparer.prepare(raw), throwsA(isA<DocumentUnreadable>()));
    });

    test('reports unreadable when the compressor throws', () async {
      final raw = await writeFile('broken.jpg', [0]);
      final preparer = FilePreparer(
        compress: (_, _) async => throw Exception('decode error'),
        workDir: workDir,
      );
      expect(() => preparer.prepare(raw), throwsA(isA<DocumentUnreadable>()));
    });
  });

  test('rejects unsupported types', () async {
    final raw = await writeFile('notes.docx', [1]);
    expect(
      () => FilePreparer(workDir: workDir).prepare(raw),
      throwsA(isA<DocumentUnsupportedType>()),
    );
  });

  test('discard deletes only temporary copies', () async {
    final temp = await writeFile('a.pdf', [1], temporary: true);
    final original = await writeFile('b.pdf', [1]);
    final preparer = FilePreparer(workDir: workDir);

    await preparer.discard(temp);
    await preparer.discard(original);

    expect(File(temp.path).existsSync(), isFalse);
    expect(File(original.path).existsSync(), isTrue);
  });
}
