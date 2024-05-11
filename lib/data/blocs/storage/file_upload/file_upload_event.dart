part of 'file_upload_bloc.dart';

@immutable
@Freezed(
  copyWith: false,
  toStringOverride: false,
  equal: false,
  when: FreezedWhenOptions.none,
  map: FreezedMapOptions.none,
)
class FileUploadEvent with _$FileUploadEvent {
  const factory FileUploadEvent.uploadFile(XFile file, {required String path}) = _UploadFile;
}
