part of 'upload_cubit.dart';

@freezed
class UploadState with _$UploadState {
  const factory UploadState.initial() = _Initial;
  const factory UploadState.loading() = _Loading;
  const factory UploadState.loaded(List<UploadFileObject> objects) = _UploadLoaded;
  const factory UploadState.error(String error) = _UploadErro;
}

@freezed
class FileState with _$FileState {
  const factory FileState.onUploadStart() = _onUploadStarted;
  const factory FileState.onUploadProgress(double progress) = _onUploadProgres;
  const factory FileState.onUploadCompleted() = _onUploadCompleted;
}
