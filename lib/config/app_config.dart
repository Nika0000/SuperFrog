import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppConfig {
  static bool _initialized = false;

  static AppConfig? _instance;

  AppConfig._();

  factory AppConfig() {
    _instance ??= AppConfig._();
    return _instance!;
  }

  bool get isInitialized => _initialized;

  static late SharedPreferences _preferences;
  static SharedPreferences get preferences => _preferences;

  static Future<void> initialize() async {
    if (!_initialized) {
      WidgetsFlutterBinding.ensureInitialized();
      EasyLocalization.logger.enableBuildModes = [];

      await Future.wait(
        [
          //Localization
          EasyLocalization.ensureInitialized(),

          //System UI Styles
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]),

          //Supabase
          Supabase.initialize(
            url: const String.fromEnvironment('SUPABASE_URL'),
            anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
            debug: kDebugMode,
          ),

          //SharedPreferences
          SharedPreferences.getInstance().then((pref) => _preferences = pref),
        ],
      ).whenComplete(() => _initialized = true);
    }
  }
}
