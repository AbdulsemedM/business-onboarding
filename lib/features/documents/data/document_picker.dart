import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'models/document_error.dart';
import 'models/document_source.dart';
import 'models/local_file.dart';

/// Lets the user choose a file from the camera, photo library, or files.
abstract interface class DocumentPicker {
  /// Returns null if the user cancelled.
  /// Throws [DocumentError] (e.g. permission denied).
  Future<LocalFile?> pick(DocumentSource source);
}

class DeviceDocumentPicker implements DocumentPicker {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<LocalFile?> pick(DocumentSource source) async {
    try {
      return switch (source) {
        DocumentSource.camera => await _pickImage(ImageSource.camera),
        DocumentSource.gallery => await _pickImage(ImageSource.gallery),
        DocumentSource.files => await _pickFile(),
      };
    } on PlatformException catch (e) {
      // iOS reports "camera_access_denied" / "photo_access_denied".
      if (e.code.contains('access_denied')) {
        throw const DocumentError.permissionDenied();
      }
      throw const DocumentError.unreadable();
    }
  }

  // TODO(android): handle ImagePicker.retrieveLostData() for when Android
  // kills the app while the camera is open.
  Future<LocalFile?> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      // We don't need location or other metadata.
      requestFullMetadata: false,
    );
    if (image == null) return null;
    return LocalFile(
      path: image.path,
      name: image.name,
      sizeBytes: await File(image.path).length(),
      isTemporaryCopy: true,
    );
  }

  Future<LocalFile?> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedFileExtensions,
    );
    final file = result?.files.single;
    final path = file?.path;
    if (file == null || path == null) return null;
    return LocalFile(
      path: path,
      name: file.name,
      sizeBytes: file.size,
      // file_picker copies picked files into the app cache.
      isTemporaryCopy: true,
    );
  }
}
