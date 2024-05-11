part of 'file_upload_bloc.dart';

@Freezed(
  copyWith: false,
  toStringOverride: false,
  equal: false,
  when: FreezedWhenOptions(when: false),
  map: FreezedMapOptions.none,
)
class FileUploadState with _$FileUploadState {
  const factory FileUploadState.unitialized() = _FileUnitialized;
  const factory FileUploadState.fileUploading(FileMetadata metadata) = _FileUploading;
  const factory FileUploadState.fileUploaded(FileMetadata metadata) = _FileUploaded;
  const factory FileUploadState.fileUploadingError(FileMetadata metadata, String error) = _FileUploadingError;
}
