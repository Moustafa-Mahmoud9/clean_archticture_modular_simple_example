
enum FileExtension {
  // ── Images ─────────────────────────────────────────────────────────────────
  jpg('jpg', 'image/jpeg'),
  jpeg('jpeg', 'image/jpeg'),
  png('png', 'image/png'),
  gif('gif', 'image/gif'),
  webp('webp', 'image/webp'),
  heic('heic', 'image/heic'),
  svg('svg', 'image/svg+xml'),

  // ── Documents ──────────────────────────────────────────────────────────────
  pdf('pdf', 'application/pdf'),
  doc('doc', 'application/msword'),
  docx('docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
  xls('xls', 'application/vnd.ms-excel'),
  xlsx('xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  ppt('ppt', 'application/vnd.ms-powerpoint'),
  txt('txt', 'text/plain'),

  // ── Audio ──────────────────────────────────────────────────────────────────
  mp3('mp3', 'audio/mpeg'),
  wav('wav', 'audio/wav'),
  aac('aac', 'audio/aac'),

  // ── Video ──────────────────────────────────────────────────────────────────
  mp4('mp4', 'video/mp4'),
  mov('mov', 'video/quicktime'),
  avi('avi', 'video/x-msvideo'),

  // ── Archives ───────────────────────────────────────────────────────────────
  zip('zip', 'application/zip'),
  rar('rar', 'application/x-rar-compressed'),

  // ── Generic binary fallback ────────────────────────────────────────────────
  binary('bin', 'application/octet-stream');

  /// File extension without the leading dot — e.g. 'jpg', 'pdf'.
  final String extension;

  /// MIME content type — e.g. 'image/jpeg', 'application/pdf'.
  final String mimeType;

  const FileExtension(this.extension, this.mimeType);

  /// Returns the [FileExtension] matching [ext], or [binary] as fallback.
  ///
  /// Example:
  /// ```dart
  /// final type = FileExtension.fromExtension('pdf'); // → FileExtension.pdf
  /// ```
  static FileExtension fromExtension(String ext) {
    return FileExtension.values.firstWhere(
          (e) => e.extension == ext.toLowerCase().replaceAll('.', ''),
      orElse: () => FileExtension.binary,
    );
  }

  /// Returns the [FileExtension] matching [mime], or [binary] as fallback.
  static FileExtension fromMimeType(String mime) {
    return FileExtension.values.firstWhere(
          (e) => e.mimeType == mime.toLowerCase(),
      orElse: () => FileExtension.binary,
    );
  }
}