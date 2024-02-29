// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Preferences {
  static const _preferencesBox = 'preferences';
  static const _keyTheme = 'theme';

  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_preferencesBox);
  }

  static ThemeMode get currentTheme => ThemeMode.values[_box.get(_keyTheme, defaultValue: ThemeMode.system.index)];

  static set setTheme(ThemeMode value) => _box.put(_keyTheme, value.index);

  void close() async {
    await _box.close();
  }

  /* static Future<void> init() async {
    Hive.registerAdapter();
    var box = await Hive.openBox<Preferences>(_preferencesBox);
  }

  static Future<ThemeMode> get currentTheme async => switch (await _getValue(_keyTheme, defaultValue: 'system')) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };

  static set setTheme(ThemeMode? mode) => mode != null ? _setValue(_keyTheme, mode.name) : null;

  static Future<T> _getValue<T>(Object key, {required T defaultValue}) async {
    final box = await Hive.openBox<Object>(_preferencesBox);
    return box.get(key, defaultValue: defaultValue) as T;
  }

  Future<T?> _getValueOrNull<T>(Object key) async {
    final box = await Hive.openBox<Object>(_preferencesBox);
    return box.get(key) as T?;
  }

  static Future<void> _setValue(String key, Object value) async {
    print('setvalue');
    final box = await Hive.openBox<Object>(_preferencesBox);
    return box.put(key, value);
  } */
}
