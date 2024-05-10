import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superfrog/app/app_view.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/config/app_config.dart';
import 'package:superfrog/utils/localization_manager.dart';

Future<void> main() async {
  await AppConfig.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      useFallbackTranslations: true,
      path: LocalizationManager.localePath,
      fallbackLocale: Languages.en.locale,
      child: MultiBlocProvider(
        providers: CommonBloc.blocProvider,
        child: const AppView(),
      ),
    ),
  );
}
