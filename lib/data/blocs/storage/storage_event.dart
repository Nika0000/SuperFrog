part of 'storage_bloc.dart';

@immutable
@Freezed(
  copyWith: false,
  toStringOverride: false,
  equal: false,
  when: FreezedWhenOptions.none,
  map: FreezedMapOptions.none,
)
class StorageEvent with _$StorageEvent {
  const factory StorageEvent.uploadFiles({
    required List<XFile> files,
    String? path,
  }) = _StorageUploadFile;

  const factory StorageEvent.downloadFile() = _StorageDownloadFile;
}
