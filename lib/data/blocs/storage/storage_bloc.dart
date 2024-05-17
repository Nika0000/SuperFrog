import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/data/model/file_metadata.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:superfrog/utils/catch_async.dart';

part 'storage_state.dart';
part 'storage_event.dart';
part 'storage_bloc.freezed.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StorageService _storageService = GetIt.I.get<StorageService>();

  StorageBloc() : super(const StorageState.unitialized()) {
    on<_GoDirectory>(
      (event, emit) => catchAsync(
        () async {
          emit(const StorageState.loading());

          final res = await _storageService.queryFiles(path: event.path);

          res.removeWhere((file) => file.name == '.emptyFolderPlaceholder');

          emit(StorageState.loaded(res, event.path ?? ""));
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

          for (FileMetadatas file in event.files) {
            final dir = file.directory.isEmpty ? file.directory : "${file.directory}/";
            if (!file.isDirectory) {
              filesToDelete.add("$dir${file.fileName}");
            } else {
              filesToDelete.add("$dir${file.fileName}/.emptyFolderPlaceholder");
            }
          }

          await _storageService.deleteFile(filesToDelete);
          add(StorageEvent.goDirectory(event.files.last.directory));
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
          emit(const StorageState.unitialized());
        },
        onError: (error) => emit(StorageState.error(error)),
      ),
    );
  }
}
