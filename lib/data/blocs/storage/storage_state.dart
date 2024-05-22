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
  const factory StorageState.loading() = _Loading;
  const factory StorageState.loaded(List<FileObject> files, String directory) = _StorageLoadeds;
  const factory StorageState.error(String error) = _StorageError;
}
