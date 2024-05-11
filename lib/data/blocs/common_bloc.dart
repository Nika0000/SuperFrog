import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/storage/file_upload/file_upload_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';
import 'package:superfrog/utils/theme_provider.dart';

class CommonBloc {
  CommonBloc._();
  static final authenticationBloc = AuthenticationBloc();
  static final storageBloc = StorageBloc();
  static final fileUploadBloc = FileUploadBloc();
  static final themeProvider = ThemeProvider();

  static List<BlocProvider> get blocProvider => [
        BlocProvider<AuthenticationBloc>(create: (_) => authenticationBloc),
        BlocProvider<StorageBloc>(create: (_) => storageBloc),
        BlocProvider<FileUploadBloc>(create: (_) => fileUploadBloc),
        BlocProvider<ThemeProvider>(create: (_) => themeProvider),
      ];

  Future<void> close() async {
    await authenticationBloc.close();
    await storageBloc.close();
    await fileUploadBloc.close();
    await themeProvider.close();
  }
}
