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
  const factory StorageState.onProgress() = _StorageOnProgress;
  const factory StorageState.onDownloadFinished() = _StorageDownloadFinished;
  const factory StorageState.onUploadFinished() = _StorageUploadFinished;
  const factory StorageState.error() = _StorageError;
}
