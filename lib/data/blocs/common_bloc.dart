import 'package:superfrog/app/app_view.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/storage/file_upload/file_upload_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';
import 'package:superfrog/utils/theme_provider.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class CommonBloc {
  CommonBloc._();

  static void register() {
    getIt.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc());
    getIt.registerLazySingleton<StorageBloc>(() => StorageBloc());
    getIt.registerLazySingleton<FileUploadBloc>(() => FileUploadBloc());
    getIt.registerLazySingleton<ThemeProvider>(() => ThemeProvider());

    getIt.registerLazySingleton(() => ScaffoldMessengerKeySingleton());
  }
}
