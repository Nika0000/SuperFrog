import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/storage/file_upload/file_upload_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';
import 'package:superfrog/utils/theme_provider.dart';
import 'package:get_it/get_it.dart';

class CommonBloc {
  CommonBloc._();

  static void register() {
    GetIt.I.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc());
    GetIt.I.registerLazySingleton<StorageBloc>(() => StorageBloc());
    GetIt.I.registerLazySingleton<FileUploadBloc>(() => FileUploadBloc());
    GetIt.I.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  }
}
