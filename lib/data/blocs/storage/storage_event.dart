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
  const factory StorageEvent.uploadFile() = _StorageUploadFile;
  const factory StorageEvent.downloadFile() = _StorageDownloadFile;
}
