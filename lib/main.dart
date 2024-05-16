import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:superfrog/app/app_view.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/config/app_config.dart';
import 'package:superfrog/data/blocs/storage/file_upload/file_upload_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';
import 'package:superfrog/utils/localization_manager.dart';
import 'package:superfrog/utils/theme_provider.dart';

Future<void> main() async {
  await AppConfig.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      useFallbackTranslations: true,
      path: LocalizationManager.localePath,
      fallbackLocale: Languages.en.locale,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: GetIt.instance.get<AuthenticationBloc>()),
          BlocProvider.value(value: GetIt.instance.get<StorageBloc>()),
          BlocProvider.value(value: GetIt.instance.get<FileUploadBloc>()),
          BlocProvider.value(value: GetIt.instance.get<ThemeProvider>()),
        ],
        child: const AppView(),
      ),
    ),
  );
}
