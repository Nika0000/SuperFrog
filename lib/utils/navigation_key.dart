import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigationKeySingleton {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static void register() {
    GetIt.I.registerLazySingleton(() => NavigationKeySingleton());
  }
}
