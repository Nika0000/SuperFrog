import 'package:flutter/material.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }
}

extension Responsive on BuildContext {
  bool get isMobile {
    return MediaQuery.of(this).size.width < 600;
  }

  bool get isTablet {
    return MediaQuery.of(this).size.width >= 600 && MediaQuery.of(this).size.width < 1200;
  }

  bool get isDesktop {
    return MediaQuery.of(this).size.width >= 1200 && MediaQuery.of(this).size.width < 1440;
  }

  bool get isDesktopLarge {
    return MediaQuery.of(this).size.width >= 1440;
  }

  T responsive<T>(T defaultValue, {T? sm, T? md, T? lg, T? xl}) {
    return isDesktopLarge
        ? (xl ?? lg ?? md ?? sm ?? defaultValue)
        : isDesktop
            ? (lg ?? md ?? sm ?? defaultValue)
            : isTablet
                ? (md ?? sm ?? defaultValue)
                : isMobile
                    ? (sm ?? defaultValue)
                    : defaultValue;
  }

  T responsiveWhen<T>(T defaultValue, {T? sm, T? md, T? lg, T? xl}) {
    return isDesktopLarge
        ? (xl ?? defaultValue)
        : isDesktop
            ? (lg ?? defaultValue)
            : isTablet
                ? (md ?? defaultValue)
                : isMobile
                    ? (sm ?? defaultValue)
                    : defaultValue;
  }
}
