import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:superfrog/data/models/tus_file.dart';
import 'package:superfrog/data/services/storage_service.dart';
import 'package:uuid/uuid.dart';

part 'upload_state.dart';
part 'upload_cubit.freezed.dart';

class UploadCubit extends Cubit<UploadState> {
  late Box uploadBox;
  final StorageService _storageService = StorageService();

  UploadCubit() : super(const UploadState.initial()) {
    emit(const UploadState.loading());
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UploadFileObjectAdapter());
    }

    Hive.openBox<UploadFileObject>('tus_uploads').then((box) async {
      uploadBox = box;
      _refresh();
    });
  }

  void addFile(XFile file) async {
    String objectId = const Uuid().v4();

    final uploadObject = UploadFileObject(
      objectId: objectId,
      uploadUrl: Uri.parse(''),
      filePath: file.path,
      destination: '/',
      createdAt: DateTime.now(),
    );

    await uploadBox.put(objectId, uploadObject);
    _refresh();
  }

  Future<void> removeFile(String objectId) async {
    await uploadBox.delete(objectId);
    _refresh();
  }

  void upload(String objectId) async {
    state.maybeWhen(loaded: (objects) {
      UploadFileObject uploadObject = objects.singleWhere((obj) => obj.objectId == objectId);
      final XFile file = XFile(
        uploadObject.filePath,
        mimeType: lookupMimeType(uploadObject.filePath),
      );

      _storageService.uploadFile(
        file: file,
        onStart: (v, v2) {},
        onProgress: (onProgress, duration) {},
        onCompleted: () {},
      );
    }, orElse: () {
      emit(const UploadState.error('file not found'));
    });
  }

  void pause(String objectId) async {}

  void cancel(String objectId) async {
    //_tusClient.cancel()
    removeFile(objectId);
  }

  void _refresh() {
    final resumableList = uploadBox.values.toList() as List<UploadFileObject>;
    emit(UploadState.loaded(resumableList));
  }

  @override
  Future<void> close() async {
    await uploadBox.close();
    return super.close();
  }
}
