import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/data/models/tus_file.dart';
import 'package:tus_client_dart/tus_client_dart.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> uploadFile({
    required XFile file,
    String? path,
    Function(TusClient client, Duration? duration)? onStart,
    Function(double, Duration)? onProgress,
    Function()? onCompleted,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final tempDirectory = Directory('${tempDir.path}/tus_uploads');
    if (!tempDirectory.existsSync()) {
      tempDirectory.createSync(recursive: true);
    }

    String endpoint = '${_supabase.storage.url}/upload/resumable';

    final tusClient = TusClient(
      file,
      retries: 3,
      retryInterval: 1,
      store: TusFileStore(tempDirectory),
    );

    await tusClient.upload(
      uri: Uri.parse(endpoint),
      onComplete: onCompleted,
      onStart: onStart,
      onProgress: onProgress,
      headers: {
        "authorization": "Bearer ${_supabase.auth.currentSession?.accessToken}",
        "x-upsert": "true",
      },
      metadata: {
        "bucketName": "colo",
        "objectName": file.name,
        "contentType": file.mimeType ?? "",
        "cacheControl": "60000",
      },
    );
  }
}

class TusStore {
  final String _tusToreBox = 'tus_storage';

  Future<void> set(UploadFileObject object) async {
    Box box = await Hive.openBox<UploadFileObject>(_tusToreBox);

    await box.put(object.objectId, object);
    await box.close();
  }

  Future<UploadFileObject> get(String objectId) async {
    Box box = await Hive.openBox<UploadFileObject>(_tusToreBox);

    final UploadFileObject obj = await box.get(objectId);
    return obj;
  }

  Future<List<UploadFileObject>> list() async {
    Box box = await Hive.openBox<UploadFileObject>(_tusToreBox);

    final List<UploadFileObject> objs = box.values.toList() as List<UploadFileObject>;
    return objs;
  }

  Future<void> remove(String objectId) async {
    Box box = await Hive.openBox<UploadFileObject>(_tusToreBox);
    await box.delete(objectId);
    await box.close();
  }
}
