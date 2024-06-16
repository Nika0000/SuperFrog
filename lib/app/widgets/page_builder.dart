import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final bool useRootNavigator;
  final String? barrierLabel;
  final bool useSafeArea;
  final Curve? transitionCurve;
  final Duration? transitionDuration;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible = true,
    this.useRootNavigator = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.transitionCurve,
    this.transitionDuration,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator).context,
    );
    final Color effectiveBarrierColor =
        barrierColor ?? context.moonTheme?.modalTheme.colors.barrierColor ?? MoonColors.light.zeno;

    final Curve effectiveTransitionCurve =
        transitionCurve ?? context.moonTheme?.modalTheme.properties.transitionCurve ?? Curves.easeInOutCubic;

    final Duration effectiveTransitionDuration = transitionDuration ??
        context.moonTheme?.modalTheme.properties.transitionDuration ??
        const Duration(milliseconds: 200);

    return MoonModalRoute<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: effectiveBarrierColor,
      transitionCurve: effectiveTransitionCurve,
      transitionDuration: effectiveTransitionDuration,
      useSafeArea: useSafeArea,
      settings: this,
      anchorPoint: anchorPoint,
      themes: themes,
    );
  }
}

class BottomSheetPage<T> extends Page<T> {
  final bool enableDrag;
  final bool isExpanded;
  final bool isDismissible;
  final bool useRootNavigator;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? barrierColor;
  final Decoration? decoration;
  final double? closeProgressThreshold;
  final double? height;
  final Duration? transitionDuration;
  final Curve? transitionCurve;
  final String? semanticLabel;
  final WidgetBuilder builder;

  const BottomSheetPage({
    required this.builder,
    this.enableDrag = true,
    this.isExpanded = false,
    this.isDismissible = true,
    this.useRootNavigator = false,
    this.borderRadius,
    this.backgroundColor,
    this.barrierColor,
    this.decoration,
    this.closeProgressThreshold,
    this.height,
    this.transitionDuration,
    this.transitionCurve,
    this.semanticLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    final bool hasMaterialLocalizations =
        Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;

    final String barrierLabel =
        hasMaterialLocalizations ? MaterialLocalizations.of(context).modalBarrierDismissLabel : '';

    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: this.useRootNavigator).context,
    );

    final Color effectiveBarrierColor =
        barrierColor ?? context.moonTheme?.modalTheme.colors.barrierColor ?? MoonColors.light.zeno;

    final Curve effectiveTransitionCurve =
        transitionCurve ?? context.moonTheme?.modalTheme.properties.transitionCurve ?? Curves.easeInOutCubic;

    final Duration effectiveTransitionDuration = transitionDuration ??
        context.moonTheme?.modalTheme.properties.transitionDuration ??
        const Duration(milliseconds: 200);

    return MoonModalBottomSheetRoute<T>(
      enableDrag: enableDrag,
      isExpanded: isExpanded,
      isDismissible: isDismissible,
      borderRadius: borderRadius,
      themes: themes,
      backgroundColor: backgroundColor,
      modalBarrierColor: effectiveBarrierColor,
      decoration: decoration,
      closeProgressThreshold: closeProgressThreshold,
      height: height,
      animationDuration: effectiveTransitionDuration,
      animationCurve: effectiveTransitionCurve,
      settings: this,
      semanticLabel: semanticLabel,
      barrierLabel: barrierLabel,
      builder: builder,
    );
  }
}
