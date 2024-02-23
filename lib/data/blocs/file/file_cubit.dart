import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:tus_client_dart/tus_client_dart.dart';

part 'file_state.dart';
part 'file_cubit.freezed.dart';

class FileCubit extends Cubit<FileState> {
  final String objectId;
  final XFile file;
  final String? path;

  FileCubit({
    required this.objectId,
    required this.file,
    this.path,
  }) : super(const FileState.initial());

  final StorageService _storageService = StorageService();
  bool _isUploading = false;

  TusClient? _client;

  void uploadFile() async {
    if (_isUploading) return;

    _isUploading = true;

    await _storageService.uploadFile(
      file: file,
      path: path,
      onStart: (TusClient client, Duration? duration) async {
        _client = client;

        emit(const FileState.onStart());
      },
      onProgress: (p1, p2) {
        print("${p2.inHours.toString()} sec");
        emit(FileState.onProgress(p1 / 100));
      },
      onCompleted: () {
        emit(const FileState.onCompleted());
        _isUploading = false;
      },
    );

    _isUploading = false;
  }

  void resume() async {
    if (_client == null) {
      return emit(const FileState.onError("Client unitialized"));
    }

    if (!await _client!.isResumable()) {
      return emit(const FileState.onError('Upload cannot be a resumed'));
    }

    uploadFile();
  }

  void pause() {
    if (_client == null) {
      emit(const FileState.onError("Client unitialized"));
    }

    _client!.pauseUpload();

    emit(const FileState.onPaused());
  }
}
