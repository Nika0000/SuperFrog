import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/app/widgets/systemerror_widget.dart';
import 'package:superfrog/config/preference_config.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/data/services/common_service.dart';
import 'package:superfrog/utils/navigation_key.dart';
import 'package:url_strategy/url_strategy.dart';

class AppConfig {
  static bool _initialized = false;

  static AppConfig? _instance;

  AppConfig._();

  factory AppConfig() {
    _instance ??= AppConfig._();
    return _instance!;
  }

  bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (!_initialized) {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLocalization.logger.enableBuildModes = [];

      ErrorWidget.builder = (FlutterErrorDetails errorDetails) => systemErrorWidget(errorDetails);

      if (kIsWeb) {
        setPathUrlStrategy();
      }

      await Future.wait(
        [
          //Localization
          EasyLocalization.ensureInitialized(),

          //System UI Styles
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]),

          //Hive & Preferences
          Hive.initFlutter().then((value) => Preferences.init()),

          //Supabase
          Supabase.initialize(
            url: const String.fromEnvironment('SUPABASE_URL'),
            anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
            debug: kDebugMode,
          ),
        ],
      );

      //GetIt
      CommonBloc.register();
      CommonService.register();
      RootNavigationKey.register();

      _initialized = true;
    }
  }
}
