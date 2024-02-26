import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:tus_client_dart/tus_client_dart.dart';

part 'file_state.dart';
part 'file_cubit.freezed.dart';

class FileCubit extends Cubit<FileState> {
  final String filePath;
  late XFile _file;

  FileCubit({required this.filePath}) : super(const FileState.initial()) {
    _file = XFile(filePath);
  }

  final StorageService _storageService = StorageService();
  TusClient? _client;

  void uploadFile() async {
    await _storageService.uploadFile(
      file: _file,
      onStart: (TusClient client, Duration? duration) async {
        _client = client;

        emit(const FileState.onStart());
      },
      onProgress: (p1, p2) {
        emit(FileState.onProgress(p1 / 100));
      },
      onCompleted: () async {
        // await _storageService.removeFileMetadata(objectId);

        emit(const FileState.onCompleted());
      },
    );
  }

  void resume() async {
    if (_client == null) {
      return emit(const FileState.onError("Client unitialized"));
    }

    uploadFile();
  }

  void pause() async {
    if (_client == null) {
      emit(const FileState.onError("Client unitialized"));
    }

    _client!.pauseUpload();

    emit(const FileState.onPaused());
  }
}
