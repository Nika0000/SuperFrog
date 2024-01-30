import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum Languages {
  en(Locale('en'), 'English');

  final Locale locale;
  final String name;
  const Languages(this.locale, this.name);
}

class LocalizationManager {
  static Languages of(BuildContext context) {
    String currentLocale = context.locale.languageCode;

    switch (currentLocale) {
      case 'en':
        return Languages.en;
      default:
        return Languages.en;
    }
  }

  static const String localePath = 'assets/locales';

  static List<Locale> get supportedLocales => [
        Languages.en.locale,
      ];
}
