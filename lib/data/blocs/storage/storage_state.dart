part of 'storage_bloc.dart';

@Freezed(
  copyWith: false,
  toStringOverride: false,
  equal: false,
  when: FreezedWhenOptions(when: false),
  map: FreezedMapOptions.none,
)
class StorageState with _$StorageState {
  const factory StorageState.unitialized() = _Unitialized;
  const factory StorageState.loading() = _StorageLoading;
  const factory StorageState.onStartUpload(String objectId) = _StorageStartUploading;
  const factory StorageState.onProgress({
    required String objectId,
    required double progress,
    required Duration estimatedTime,
  }) = _StorageOnProgress;
  const factory StorageState.onDownloadCompleted() = _StorageDownloadCompleted;
  const factory StorageState.onUploadCompleted(String objectId) = _StorageUploadCompleted;
  const factory StorageState.error({required String error, String? objectId}) = _StorageError;
}
