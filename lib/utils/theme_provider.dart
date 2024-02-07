import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/config/preference_config.dart';

class ThemeProvider extends Cubit<ThemeMode> {
  ThemeProvider() : super(PreferenceConfiguration.get().themeMode) {
    SystemChrome.setSystemUIOverlayStyle(state == ThemeMode.dark ? _darkOverlays : _lightOverlays);
  }

  ThemeMode get currentTheme => state;

  void toggleTheme({ThemeMode? mode}) {
    if (mode != null) {
      emit(mode);
    } else {
      emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    }
    SystemChrome.setSystemUIOverlayStyle(state == ThemeMode.dark ? _darkOverlays : _lightOverlays);
    PreferenceConfiguration.changeTheme(state);
  }

  static final MoonTokens _lightToken = MoonTokens.light.copyWith(
    colors: MoonColors.light.copyWith(
      piccolo: const Color(0xFF37996B),
      goku: const Color(0xFFF8F9FA),
      gohan: const Color(0xFFFBFCFD),
      beerus: const Color(0xFFE6E8EB),
      trunks: const Color(0xFF687076),
      jiren: const Color(0x2910B981),
      chichi: const Color(0xFFE5484D),
      chichi10: const Color(0x1AE5484D),
      cell60: const Color(0x99E5484D),
      krillin: const Color(0xFFF1A10D),
      krillin10: const Color(0x1AF1A10D),
      krillin60: const Color(0x99F1A10D),
      roshi: const Color(0xFF10B981),
      roshi10: const Color(0x1A10B981),
      roshi60: const Color(0x9910B981),
    ),
  );
  static final MoonTokens _darkToken = MoonTokens.dark.copyWith(
    colors: MoonColors.dark.copyWith(
      piccolo: const Color(0xFF37996B),
      goku: const Color(0xFF1C1C1C),
      gohan: const Color(0xFF232323),
      beerus: const Color(0xFF2E2E2E),
      trunks: const Color(0xFF7E7E7E),
      jiren: const Color(0x2910B981),
      chichi: const Color(0xFFE5484D),
      chichi10: const Color(0x1AE5484D),
      cell60: const Color(0x99E5484D),
      krillin: const Color(0xFFF1A10D),
      krillin10: const Color(0x1AF1A10D),
      krillin60: const Color(0x99F1A10D),
      roshi: const Color(0xFF10B981),
      roshi10: const Color(0x1A10B981),
      roshi60: const Color(0x9910B981),
    ),
  );

  static final ThemeData light = ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[MoonTheme(tokens: _lightToken)],
    scaffoldBackgroundColor: _lightToken.colors.goku,
    dividerColor: _lightToken.colors.beerus,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightToken.colors.goku,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: MoonTypography.typography.heading.text18.copyWith(color: _lightToken.colors.bulma),
      shape: Border(
        bottom: BorderSide(color: _lightToken.colors.beerus, width: 1),
      ),
    ),
    dividerTheme: DividerThemeData(color: _lightToken.colors.beerus),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _lightToken.colors.gohan,
      selectedItemColor: _lightToken.colors.bulma,
      unselectedItemColor: _lightToken.colors.trunks,
      selectedLabelStyle: MoonTypography.typography.body.text12,
      unselectedLabelStyle: MoonTypography.typography.body.text12,
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[MoonTheme(tokens: _darkToken)],
    scaffoldBackgroundColor: _darkToken.colors.goku,
    dividerColor: _darkToken.colors.beerus,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkToken.colors.goku,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: MoonTypography.typography.heading.text18.copyWith(color: _darkToken.colors.bulma),
      shape: Border(
        bottom: BorderSide(color: _darkToken.colors.beerus, width: 1),
      ),
    ),
    dividerTheme: DividerThemeData(color: _darkToken.colors.beerus),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _darkToken.colors.gohan,
      selectedItemColor: _darkToken.colors.bulma,
      unselectedItemColor: _darkToken.colors.trunks,
      selectedLabelStyle: MoonTypography.typography.body.text12,
      unselectedLabelStyle: MoonTypography.typography.body.text12,
    ),
  );

  final SystemUiOverlayStyle _darkOverlays = SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    statusBarIconBrightness: Brightness.light,
  );

  final SystemUiOverlayStyle _lightOverlays = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    statusBarIconBrightness: Brightness.dark,
  );
}
