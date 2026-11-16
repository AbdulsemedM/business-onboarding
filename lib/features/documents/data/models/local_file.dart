/// A file on the device, ready to be prepared or uploaded.
class LocalFile {
  const LocalFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
    this.mimeType,
    this.isTemporaryCopy = false,
  });

  final String path;

  /// Display name, e.g. "lease.pdf". Personal data: never log it.
  final String name;
  final int sizeBytes;
  final String? mimeType;

  /// True if this is our own copy (picker cache or compressed output) that
  /// should be deleted once it is no longer needed.
  final bool isTemporaryCopy;

  /// Lower-case extension without the dot, or '' if there is none.
  String get extension {
    final dot = name.lastIndexOf('.');
    return dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
  }
}
