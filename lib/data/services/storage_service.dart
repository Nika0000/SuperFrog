import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

import 'package:path/path.dart' as p;
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';
import 'package:mime_type/mime_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageServiceBase {
  final SupabaseStorageClient _storageClient = Supabase.instance.client.storage;
  final String _bucket = const String.fromEnvironment('SUPABASE_BUCKET_NAME');

  Future<XFile> downloadFile(String filePath);
  Future<String> uploadFile(XFile file, {String? path});
  Future<List<FileObject>> deleteFile(List<String> filePath);

  Future<void> createDirectory(String path);

  Future<List<FileObject>> queryFiles({required String path, SearchOptions searchOptions = const SearchOptions()});
  Future<void> moveFile(String fromPath, String toPath);
  Future<void> copyFile(String fromPath, String toPath);

  //local
  Future<void> saveFile(XFile file);
}

class StorageService extends StorageServiceBase {
  @override
  Future<void> copyFile(String fromPath, String toPath) async {
    await _storageClient.from(_bucket).copy(fromPath, toPath);
  }

  @override
  Future<List<FileObject>> deleteFile(List<String> filePath) async {
    if (filePath.isEmpty) {
      throw 'There is nothing to remove.';
    }

    return await _storageClient.from(_bucket).remove(filePath.toSet().toList());
  }

  @override
  Future<XFile> downloadFile(String filePath) async {
    late XFile uploadFile;

    Stream<Uint8List> dataStreams = _storageClient.from(_bucket).download(filePath).asStream();

    await for (Uint8List chunk in dataStreams) {
      final mimeType = mime(filePath);
      final fileName = p.basename(filePath);

      if (kIsWeb) {
        uploadFile = XFile.fromData(
          chunk,
          name: fileName,
          mimeType: mimeType,
        );
      } else {
        Directory tempPath = await getTemporaryDirectory();

        File tempFile = await File('${tempPath.path}/$filePath').writeAsBytes(chunk);
        uploadFile = XFile(tempFile.path, mimeType: mimeType);
      }
    }

    return uploadFile;
  }

  @override
  Future<List<FileObject>> queryFiles({
    String? path,
    SearchOptions searchOptions = const SearchOptions(),
  }) async {
    if (path != null) {
      p.normalize(path);
    }

    return await _storageClient.from(_bucket).list(path: path, searchOptions: searchOptions);
  }

  @override
  Future<void> moveFile(String fromPath, String toPath) async {
    await _storageClient.from(_bucket).move(fromPath, toPath);
  }

  @override
  Future<String> uploadFile(XFile file, {String? path}) async {
    return await _storageClient.from(_bucket).uploadBinary(
          '$path/${file.name}',
          await file.readAsBytes(),
          fileOptions: const FileOptions(upsert: true),
        );
  }

  @override
  Future<void> saveFile(XFile file) async {
    if (kIsWeb) {
      html.AnchorElement anchorElement = html.AnchorElement(href: file.path);
      anchorElement.download = file.name;
      anchorElement.click();
    } else {
      if (await File(file.path).exists()) {
        final String androidDownloadDirPath = p.join('/storage/emulated/0/Download/', file.name);
        final String downloadDirPath = await getDownloadsDirectory().then(
          (dir) => dir == null ? throw 'Failed to get download directory' : p.join(dir.path, file.name),
        );

        final String path = Platform.isAndroid ? androidDownloadDirPath : downloadDirPath;

        await File(path).writeAsBytes(await file.readAsBytes()).then((_) {
          //Delete temp file
          //File(file.path).deleteSync();
        });
      } else {
        throw 'File not exits';
      }
    }
  }

  @override
  Future<void> createDirectory(String path) async {
    await _storageClient.from(_bucket).uploadBinary(p.join(path, '.emptyFolderPlaceholder'), Uint8List(0));
  }
}
