import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moon_design/moon_design.dart';

class MenuButton extends StatefulWidget {
  /// The widget to display before the [label] widget of the menu item.
  final Widget? leading;

  /// The primary content of the menu item header.
  final Widget label;

  /// The widget to display after the [label] widget of the menu item.
  final Widget? trailing;

  final dynamic value;

  final dynamic groupValue;

  final MoonButtonSize? buttonSize;

  /// The border radius of the menu item.
  final BorderRadiusGeometry? borderRadius;

  /// The background color of the menu item.
  final Color? backgroundColor;

  /// The duration of the menu item hover effect.
  final Duration? hoverEffectDuration;

  /// The curve of the menu item hover effect.
  final Curve? hoverEffectCurve;

  /// The callback that is called when the button is tapped or pressed.
  final VoidCallback? onTap;

  /// The callback that is called when the button is long-pressed.
  final VoidCallback? onLongPresse;

  const MenuButton({
    this.leading,
    required this.label,
    this.trailing,
    this.value,
    this.groupValue,
    this.borderRadius,
    this.buttonSize,
    this.backgroundColor,
    this.hoverEffectDuration,
    this.hoverEffectCurve,
    this.onTap,
    this.onLongPresse,
    super.key,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin {
  final ColorTweenWithPremultipliedAlpha _textColorTween = ColorTweenWithPremultipliedAlpha();
  final ColorTweenWithPremultipliedAlpha _backgroundColorTween = ColorTweenWithPremultipliedAlpha();

  AnimationController? _animationController;
  Animation<Color?>? _backgroundColor;
  Animation<Color?>? _textColor;

  bool get _isEnabled => widget.onTap != null || widget.onLongPresse != null;

  void _handleActiveStatus(bool isActive) {
    isActive ? _animationController!.forward() : _animationController!.reverse();
  }

  @override
  void dispose() {
    _animationController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.value == widget.groupValue;

    final BorderRadiusGeometry effectiveBorderRadius = widget.borderRadius ??
        context.moonTheme?.menuItemTheme.properties.borderRadius ??
        MoonBorders.borders.interactiveSm;

    final TextStyle effectiveLabelTextStyle =
        context.moonTheme?.menuItemTheme.properties.contentTextStyle ?? MoonTypography.typography.body.textDefault;

    final Color effectiveBackgroundColor =
        widget.backgroundColor ?? context.moonTheme?.menuItemTheme.colors.backgroundColor ?? Colors.transparent;

    final Color effectiveHoverEffectColor = context.moonEffects?.controlHoverEffect.primaryHoverColor ??
        MoonEffectsTheme(tokens: MoonTokens.light).controlHoverEffect.primaryHoverColor;

    final Color resolvedHoverColor =
        Color.alphaBlend(effectiveHoverEffectColor, widget.backgroundColor ?? Colors.transparent);

    final Duration effectiveHoverEffectDuration = widget.hoverEffectDuration ??
        context.moonEffects?.controlHoverEffect.hoverDuration ??
        MoonEffectsTheme(tokens: MoonTokens.light).controlHoverEffect.hoverDuration;

    final Curve effectiveHoverEffectCurve = widget.hoverEffectCurve ??
        context.moonEffects?.controlHoverEffect.hoverCurve ??
        MoonEffectsTheme(tokens: MoonTokens.light).controlHoverEffect.hoverCurve;

    _animationController ??= AnimationController(duration: effectiveHoverEffectDuration, vsync: this);

    _backgroundColor ??=
        _animationController!.drive(_backgroundColorTween.chain(CurveTween(curve: effectiveHoverEffectCurve)));

    _textColor ??= _animationController!.drive(_textColorTween.chain(CurveTween(curve: effectiveHoverEffectCurve)));

    _backgroundColorTween
      ..begin = effectiveBackgroundColor
      ..end = resolvedHoverColor;

    _textColorTween
      ..begin = context.moonColors!.textSecondary
      ..end = context.moonColors!.textPrimary;

    return MoonBaseControl(
      onTap: widget.onTap,
      onLongPress: widget.onLongPresse,
      builder: (context, isEnabled, isHovered, isFocused, isPressed) {
        final bool canAnimate = isEnabled && (isHovered || isFocused || isPressed);

        if (isActive) {
          _animationController!.forward();
        } else {
          _handleActiveStatus(canAnimate);
        }

        return AnimatedBuilder(
          animation: _animationController!,
          builder: (BuildContext context, Widget? child) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: ShapeDecoration(
                color: isActive ? _backgroundColor!.value : null,
                shape: MoonSquircleBorder(
                  borderRadius: effectiveBorderRadius.squircleBorderRadius(context),
                ),
              ),
              child: IconTheme(
                data: IconThemeData(color: _textColor!.value),
                child: DefaultTextStyle(
                  style: effectiveLabelTextStyle.copyWith(color: _textColor!.value),
                  child: Container(
                    color: _backgroundColor!.value,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leading != null)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.0),
                  child: widget.leading,
                ),
              widget.label,
              if (widget.trailing != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child: widget.trailing,
                )
            ],
          ),
        );
      },
    );
  }
}
