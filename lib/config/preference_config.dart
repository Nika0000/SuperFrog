// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:superfrog/config/app_config.dart';

class PreferenceConfiguration {
  bool isFirstTime;
  ThemeMode themeMode;

  PreferenceConfiguration({this.isFirstTime = DEFAULT_IS_FIRST_TIME, this.themeMode = ThemeMode.system});

  static const String PREF_STR_FIRST_TIME = 'is_first_time';
  static const String PREF_STR_THEME_MODE = 'theme_mode';

  static const bool DEFAULT_IS_FIRST_TIME = true;
  static const String DEFAULT_THEME_MODE = 'system';

  static PreferenceConfiguration get() {
    return PreferenceConfiguration(
      isFirstTime: LocalPref.getBool(PREF_STR_FIRST_TIME) ?? DEFAULT_IS_FIRST_TIME,
      themeMode: stringToThemeMode(LocalPref.getString(PREF_STR_THEME_MODE)),
    );
  }

  static Future<void> reset() async {
    await Future.wait([
      LocalPref.remove(PREF_STR_FIRST_TIME),
      LocalPref.remove(PREF_STR_THEME_MODE),
    ]);
  }

  static ThemeMode stringToThemeMode(String? theme) {
    return switch (theme) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  static void changeTheme(ThemeMode mode) {
    LocalPref.setString(PREF_STR_THEME_MODE, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

class LocalPref {
  static Future<bool> clear() {
    return AppConfig.preferences.clear();
  }

  static bool containsKey(String key) {
    return AppConfig.preferences.containsKey(key);
  }

  static dynamic get(String key) {
    return AppConfig.preferences.get(key);
  }

  static bool? getBool(String key) {
    return AppConfig.preferences.getBool(key);
  }

  static double? getDouble(String key) {
    return AppConfig.preferences.getDouble(key);
  }

  static int? getInt(String key) {
    return AppConfig.preferences.getInt(key);
  }

  static Set<String> getKeys() {
    return AppConfig.preferences.getKeys();
  }

  static String? getString(String key) {
    return AppConfig.preferences.getString(key);
  }

  static List<String>? getStringList(String key) {
    return AppConfig.preferences.getStringList(key);
  }

  static Future<void> reload() {
    return AppConfig.preferences.reload();
  }

  static Future<bool> remove(String key) {
    return AppConfig.preferences.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return AppConfig.preferences.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return AppConfig.preferences.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return AppConfig.preferences.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return AppConfig.preferences.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return AppConfig.preferences.setStringList(key, value);
  }
}
