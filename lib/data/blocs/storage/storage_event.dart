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
  const factory StorageEvent.goDirectory(String? path) = _GoDirectory;
  const factory StorageEvent.createDirectory({String? path, required String name}) = _CreateDirectory;
  const factory StorageEvent.deleteFileOrFolder(List<FileMetadata> files) = _DeleteFileOrFolder;

  const factory StorageEvent.uploadFile(XFile file, {required String path}) = _UploadFile;
}
