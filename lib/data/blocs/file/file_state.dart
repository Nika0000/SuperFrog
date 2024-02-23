part of 'file_cubit.dart';

@freezed
class FileState with _$FileState {
  const factory FileState.initial() = _Initial;
  const factory FileState.onStart() = _onStart;
  const factory FileState.onProgress(double progress) = _OnProgress;
  const factory FileState.onCompleted() = _OnCompleted;
  const factory FileState.onPaused() = _OnPaused;
  const factory FileState.onError(String message) = _OnError;
}
