import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';
import 'package:superfrog/utils/theme_provider.dart';

class CommonBloc {
  CommonBloc._();
  static final authenticationBloc = AuthenticationBloc();
  static final themeProvider = ThemeProvider();
  static final storageBloc = StorageBloc();

  static final List<BlocProvider> blocProvider = [
    BlocProvider<AuthenticationBloc>(create: (_) => authenticationBloc),
    BlocProvider<ThemeProvider>(create: (_) => themeProvider),
    BlocProvider<StorageBloc>(create: (_) => storageBloc)
  ];

  Future<void> close() async {
    await authenticationBloc.close();
    await themeProvider.close();
    await storageBloc.close();
  }
}
