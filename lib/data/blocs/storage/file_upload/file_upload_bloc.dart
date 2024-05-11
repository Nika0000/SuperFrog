import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfrog/data/model/file_metadata.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:superfrog/utils/catch_async.dart';
import 'package:uuid/uuid.dart';

part 'file_upload_state.dart';
part 'file_upload_event.dart';
part 'file_upload_bloc.freezed.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final StorageService _storageService = StorageService();

  FileUploadBloc() : super(const FileUploadState.unitialized()) {
    on<_UploadFile>(
      (event, emit) async {
        final metadata = FileMetadata(
          fileId: const Uuid().v4(),
          fileName: event.file.name,
          fileSize: await event.file.length(),
          destination: event.path,
        );
        return catchAsync(
          () async {
            emit(FileUploadState.fileUploading(metadata));

            await _storageService.uploadFile(event.file, path: event.path);

            emit(FileUploadState.fileUploaded(metadata));
          },
          onError: (error) => emit(FileUploadState.fileUploadingError(metadata, error)),
        );
      },
    );
  }
}
