class FileMetadata {
  final bool isDirectory;
  final String directory;
  final String fileName;
  final int? fileSize;

  FileMetadata({
    this.isDirectory = false,
    required this.directory,
    required this.fileName,
    this.fileSize,
  });
}
