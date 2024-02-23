import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileMetadata {
  final String objectId;
  final String uploadUrl;
  final String fingerPrint;
  final DateTime createdAt;

  const FileMetadata({
    required this.objectId,
    required this.uploadUrl,
    required this.fingerPrint,
    required this.createdAt,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) => _$FileMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);
}
