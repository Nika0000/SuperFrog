import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RootNavigationKey {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static void register() {
    GetIt.I.registerLazySingleton(() => RootNavigationKey());
  }
}
