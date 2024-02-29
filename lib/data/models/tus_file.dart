import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:superfrog/data/blocs/upload/upload_cubit.dart';

part 'tus_file.g.dart';

@HiveType(typeId: 0)
class UploadFileObject extends HiveObject {
  ValueNotifier<FileState>? state;

  @HiveField(0)
  late String objectId;

  @HiveField(1)
  late Uri uploadUrl;

  @HiveField(2)
  late String filePath;

  @HiveField(3)
  late String destination;

  @HiveField(4)
  late DateTime createdAt;

  UploadFileObject({
    this.state,
    required this.objectId,
    required this.uploadUrl,
    required this.filePath,
    required this.destination,
    required this.createdAt,
  }) {
    state = ValueNotifier(const FileState.onUploadStart());
  }

  @override
  String toString() {
    return "ObjectId: $objectId\nUploadUrl: $uploadUrl\nFilePath: $filePath\nDestination: $destination\nCreatedAt: $createdAt";
  }
}
