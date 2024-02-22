import 'package:cross_file/cross_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:superfrog/utils/catch_async.dart';
import 'package:tus_client_dart/tus_client_dart.dart';

part 'storage_state.dart';
part 'storage_event.dart';
part 'storage_bloc.freezed.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StorageService _storageService = StorageService();

  StorageBloc() : super(const StorageState.unitialized()) {
    on<_StorageUploadFile>(
      (event, emit) async => catchAsync(
        () async {
          bool isCompleted = false;

          _storageService.uploadFile(
            file: event.files.first,
            onStart: (TusClient client, Duration? duration) {
              emit(const StorageState.onStartUpload('id'));
            },
            onProgress: (double progress, Duration duration) {
              emit(
                StorageState.onProgress(
                  objectId: 'id',
                  progress: progress,
                  estimatedTime: duration,
                ),
              );
            },
            onCompleted: () => isCompleted = true,
          );

          while (!isCompleted) {
            await Future.delayed(const Duration(milliseconds: 500));
          }

          emit(const StorageState.onUploadCompleted('id'));
        },
        onError: (error) => emit(StorageState.error(error: error, objectId: 'id')),
      ),
    );
  }
}
