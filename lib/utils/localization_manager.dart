import 'package:flutter/material.dart';

enum Languages {
  en(Locale('en')),
  ka(Locale('ka'));

  final Locale locale;
  const Languages(this.locale);
}

class LocalizationManager {
  static const String localePath = 'assets/locales';

  static List<Locale> get supportedLocales => [
        Languages.en.locale,
        Languages.ka.locale,
      ];
}
