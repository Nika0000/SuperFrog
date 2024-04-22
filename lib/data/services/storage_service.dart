import 'dart:io';

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

  Future<XFile> downloadFile(String filePath);
  Future<String> uploadFile(XFile file, {String? path});
  Future<void> deleteFile(List<String> filePath);

  Future<List<FileObject>> queryFiles({required String path, required SearchOptions searchOptions});
  Future<void> moveFile(String fromPath, String toPath);
  Future<void> copyFile(String fromPath, String toPath);

  //local
  Future<void> saveFile(XFile file);
}

class StorageService extends StorageServiceBase {
  @override
  Future<void> copyFile(String fromPath, String toPath) async {
    await _storageClient.from('colo').copy(fromPath, toPath);
  }

  @override
  Future<void> deleteFile(List<String> filePath) async {
    if (filePath.isEmpty) {
      throw 'There is nothing to remove.';
    }

    await _storageClient.from('colo').remove(filePath.toSet().toList());
  }

  @override
  Future<XFile> downloadFile(String filePath) async {
    late XFile uploadFile;

    Stream<Uint8List> dataStreams = _storageClient.from('colo').download(filePath).asStream();

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
  Future<List<FileObject>> queryFiles({required String path, required SearchOptions searchOptions}) async {
    return await _storageClient.from('colo').list(path: path, searchOptions: searchOptions);
  }

  @override
  Future<void> moveFile(String fromPath, String toPath) async {
    await _storageClient.from('colo').move(fromPath, toPath);
  }

  @override
  Future<String> uploadFile(XFile file, {String? path}) async {
    return await _storageClient.from('colo').uploadBinary(
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
}
