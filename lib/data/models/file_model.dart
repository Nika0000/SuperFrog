import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileMetadata {
  final String filePath;
  final String objectId;
  final String? uploadUrl;
  final String? destination;
  final String? fingerPrint;
  final DateTime createdAt;

  FileMetadata({
    required this.filePath,
    required this.objectId,
    this.uploadUrl,
    this.destination,
    this.fingerPrint,
    required this.createdAt,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) => _$FileMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$FileMetadataToJson(this);

  FileMetadata copyWith({
    String? filePath,
    String? objectId,
    String? uploadUrl,
    String? destination,
    String? fingerPrint,
    DateTime? createdAt,
  }) {
    return FileMetadata(
      filePath: filePath ?? this.filePath,
      objectId: objectId ?? this.objectId,
      uploadUrl: uploadUrl ?? this.uploadUrl,
      destination: destination ?? this.destination,
      fingerPrint: fingerPrint ?? this.fingerPrint,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
