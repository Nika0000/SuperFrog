import 'package:cross_file/cross_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tus_client_dart/tus_client_dart.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> uploadFile({
    required XFile file,
    String? path,
    bool? pause,
    Function(TusClient client, Duration? duration)? onStart,
    Function(double, Duration)? onProgress,
    Function()? onCompleted,
    Function(Uri, XFile)? onPaused,
  }) async {
    final tusClient = TusClient(
      file,
      retries: 3,
      retryInterval: 1,
    );
    String endpoint = '${_supabase.storage.url}/upload/resumable';

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
        "cacheControl": "3600",
      },
    );
  }
}
