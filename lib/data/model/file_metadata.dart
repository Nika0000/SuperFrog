import 'package:uuid/uuid.dart';

class FileMetadata {
  final String fileId;
  final String fileName;
  final int fileSize;
  final String destination;

  const FileMetadata({
    required this.fileId,
    required this.fileName,
    required this.fileSize,
    required this.destination,
  });
}

class FileMetadatas {
  final String? fileId;
  final bool isDirectory;
  final String directory;
  final String fileName;
  final int? fileSize;

  FileMetadatas({
    String? fileId,
    this.isDirectory = false,
    required this.directory,
    required this.fileName,
    this.fileSize,
  }) : fileId = fileId ?? const Uuid().v4();
}
