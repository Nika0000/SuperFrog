import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moon_design/moon_design.dart';

class AppTheme {
  final BuildContext context;

  AppTheme._(this.context);

  factory AppTheme.of(BuildContext context) {
    return AppTheme._(context);
  }

  Brightness? get brightness => MediaQuery.platformBrightnessOf(context);

  static final MoonColors _colorsLight = MoonColors.light.copyWith();
  static final MoonColors _colorsDark = MoonColors.dark.copyWith();

  static ThemeData get light {
    return ThemeData.light().copyWith(
      extensions: <ThemeExtension<dynamic>>[MoonTheme(tokens: MoonTokens.light.copyWith(colors: _colorsLight))],
      scaffoldBackgroundColor: _colorsLight.gohan,
      dividerColor: _colorsLight.beerus,
      appBarTheme: AppBarTheme(
        backgroundColor: _colorsLight.gohan,
        titleTextStyle: MoonTypography.typography.heading.text18.copyWith(color: _colorsLight.bulma),
        shadowColor: _colorsLight.beerus,
      ),
      dividerTheme: DividerThemeData(color: _colorsLight.beerus),
    );
  }

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      extensions: <ThemeExtension<dynamic>>[MoonTheme(tokens: MoonTokens.dark.copyWith(colors: _colorsDark))],
      scaffoldBackgroundColor: _colorsDark.gohan,
      dividerColor: _colorsDark.beerus,
      appBarTheme: AppBarTheme(
        titleTextStyle: MoonTypography.typography.heading.text18.copyWith(color: _colorsDark.bulma),
        backgroundColor: _colorsDark.gohan,
        shadowColor: _colorsDark.beerus,
      ),
      dividerTheme: DividerThemeData(color: _colorsDark.beerus),
    );
  }

  SystemUiOverlayStyle get overlayStyles {
    return brightness == Brightness.dark
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarContrastEnforced: false,
            statusBarIconBrightness: Brightness.light,
          )
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarContrastEnforced: false,
            statusBarIconBrightness: Brightness.dark,
          );
  }
}
