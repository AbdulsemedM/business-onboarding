import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../core/utils/safe_log.dart';
import 'models/document_error.dart';
import 'models/local_file.dart';

/// Compresses [sourcePath] to a JPEG at [targetPath]. Returns the output
/// path, or null on failure.
typedef ImageCompressor =
    Future<String?> Function(String sourcePath, String targetPath);

/// Gets a picked file ready for upload:
/// - images (including HEIC from iPhones) are resized, compressed to JPEG,
///   and stripped of EXIF data such as GPS location;
/// - PDFs are checked to really be PDFs;
/// - anything else is rejected.
class FilePreparer {
  FilePreparer({ImageCompressor? compress, Directory? workDir})
    : _compress = compress ?? _compressWithPlugin,
      _workDir = workDir;

  static const _imageExtensions = {'jpg', 'jpeg', 'png', 'heic', 'heif'};

  final ImageCompressor _compress;
  Directory? _workDir;
  int _counter = 0;

  Future<LocalFile> prepare(LocalFile raw) async {
    final ext = raw.extension;
    if (ext == 'pdf') return _preparePdf(raw);
    if (_imageExtensions.contains(ext)) return _prepareImage(raw);
    throw const DocumentError.unsupportedType();
  }

  /// Deletes our temporary copy of [file], if it is one.
  Future<void> discard(LocalFile file) async {
    if (!file.isTemporaryCopy) return;
    try {
      final f = File(file.path);
      if (await f.exists()) await f.delete();
    } catch (_) {
      safeLog('Could not delete temporary upload file');
    }
  }

  Future<LocalFile> _preparePdf(LocalFile raw) async {
    final file = File(raw.path);
    try {
      final header = await file.openRead(0, 5).expand((b) => b).toList();
      if (String.fromCharCodes(header) != '%PDF-') {
        throw const DocumentError.unreadable();
      }
      return LocalFile(
        path: raw.path,
        name: raw.name,
        sizeBytes: await file.length(),
        mimeType: 'application/pdf',
        isTemporaryCopy: raw.isTemporaryCopy,
      );
    } on FileSystemException {
      throw const DocumentError.unreadable();
    }
  }

  Future<LocalFile> _prepareImage(LocalFile raw) async {
    final dir = await _ensureWorkDir();
    final target =
        '${dir.path}${Platform.pathSeparator}'
        '${DateTime.now().microsecondsSinceEpoch}_${_counter++}.jpg';

    String? output;
    try {
      output = await _compress(raw.path, target);
    } catch (_) {
      output = null;
    }
    if (output == null) throw const DocumentError.unreadable();

    await discard(raw);
    final baseName = raw.name.substring(0, raw.name.lastIndexOf('.'));
    return LocalFile(
      path: output,
      name: '$baseName.jpg',
      sizeBytes: await File(output).length(),
      mimeType: 'image/jpeg',
      isTemporaryCopy: true,
    );
  }

  Future<Directory> _ensureWorkDir() async {
    final existing = _workDir;
    if (existing != null) return existing;
    final dir = Directory(
      '${Directory.systemTemp.path}${Platform.pathSeparator}fastpay_uploads',
    );
    await dir.create(recursive: true);
    return _workDir = dir;
  }
}

Future<String?> _compressWithPlugin(
  String sourcePath,
  String targetPath,
) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    sourcePath,
    targetPath,
    // Long edge stays readable for ID and document text.
    minWidth: 2048,
    minHeight: 2048,
    quality: 80,
    format: CompressFormat.jpeg,
    keepExif: false,
  );
  return result?.path;
}
