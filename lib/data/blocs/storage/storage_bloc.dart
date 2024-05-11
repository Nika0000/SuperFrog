import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:superfrog/utils/catch_async.dart';

part 'storage_state.dart';
part 'storage_event.dart';
part 'storage_bloc.freezed.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StorageService _storageService = StorageService();

  StorageBloc() : super(const StorageState.unitialized()) {
    on<_GoDirectory>(
      (event, emit) => catchAsync(
        () async {
          emit(const StorageState.loading());

          final res = await _storageService.queryFiles(path: event.path);

          res.removeWhere((file) => file.name == '.emptyFolderPlaceholder');

          emit(StorageState.loaded(res, event.path ?? "/"));
        },
        onError: (error) => emit(StorageState.error(error)),
      ),
    );

    on<_CreateDirectory>(
      (event, emit) => catchAsync(
        () async {
          emit(const StorageState.loading());
          await _storageService.createDirectory(event.name);
          add(StorageEvent.goDirectory(event.path));
        },
        onError: (error) => emit(StorageState.error(error)),
      ),
    );

    on<_DeleteFileOrFolder>(
      (event, emit) => catchAsync(
        () async {
          emit(const StorageState.loading());
          List<String> filesToDelete = [];

          for (FileObject file in event.files) {
            if (file.metadata != null) {
              filesToDelete.add(file.name);
            } else {
              filesToDelete.add("${file.name}/.emptyFolderPlaceholder");
            }
          }

          await _storageService.deleteFile(filesToDelete);
          add(const StorageEvent.goDirectory(""));
        },
        onError: (error) => emit(StorageState.error(error)),
      ),
    );

    on<_UploadFile>(
      (event, emit) => catchAsync(
        () async {
          final fileId = DateTime.now().microsecond.toString();
          emit(StorageState.fileUploading(fileId));

          await _storageService.uploadFile(event.file, path: event.path);

          emit(StorageState.fileUploaded(fileId));
        },
        onError: (error) => emit(StorageState.error(error)),
      ),
    );
  }
}
