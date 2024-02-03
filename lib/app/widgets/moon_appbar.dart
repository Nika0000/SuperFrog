import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moon_design/moon_design.dart';

class MoonAppBar extends StatelessWidget {
  final Widget title;
  final double toolbarHeight;
  final TextStyle? expandedTextStyle;
  final EdgeInsetsGeometry? expandedTitlePadding;

  const MoonAppBar({
    required this.title,
    this.expandedTextStyle,
    this.expandedTitlePadding,
    this.toolbarHeight = _MediumScrollUnderFlexibleConfig.collapsedHeight,
    super.key,
  });

  @override
  SliverAppBar build(BuildContext context) {
    final double topPadding = MediaQuery.paddingOf(context).top;
    const effectiveExpandedHeight = _MediumScrollUnderFlexibleConfig.expandedHeight;
    final effectiveCollapsedHeight = topPadding + _MediumScrollUnderFlexibleConfig.collapsedHeight;

    final TextStyle effectiveExpandedTextStyle =
        expandedTextStyle ?? AppBarTheme.of(context).titleTextStyle ?? MoonTypography.typography.heading.text32;

    final Color? effectiveForegroundColor = context.moonColors?.bulma;

    return SliverAppBar.medium(
      title: title,
      centerTitle: true,
      expandedHeight: effectiveExpandedHeight,
      collapsedHeight: effectiveCollapsedHeight,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      backgroundColor: context.moonColors?.goku,
      scrolledUnderElevation: 2.0,
      foregroundColor: context.moonColors?.bulma,
      flexibleSpace: _ScrollUnderFlexibleSpace(
        title: DefaultTextStyle(
          style: effectiveExpandedTextStyle.copyWith(color: effectiveForegroundColor),
          child: title,
        ),
        bottomHeight: 0.0,
      ),
    );
  }
}

class _ScrollUnderFlexibleSpace extends StatelessWidget {
  const _ScrollUnderFlexibleSpace({
    this.title,
    required this.bottomHeight,
  });

  final Widget? title;
  final double bottomHeight;

  EdgeInsetsGeometry get expandedTitlePadding => const EdgeInsets.fromLTRB(16, 0, 16, 8);

  @override
  Widget build(BuildContext context) {
    final FlexibleSpaceBarSettings settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

    // Set maximum text scale factor to [_kMaxTitleTextScaleFactor] for the
    // title to keep the visual hierarchy the same even with larger font
    // sizes. To opt out, wrap the [title] widget in a [MediaQuery] widget
    // with a different TextScaler.
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: settings.minExtent - bottomHeight)),
        Flexible(
          child: ClipRect(
            child: _ExpandedTitleWithPadding(
                padding: expandedTitlePadding, maxExtent: settings.maxExtent - settings.minExtent, child: title),
          ),
        ),
        // Reserve space for AppBar.bottom, which is a sibling of this widget,
        // on the parent Stack.
        if (bottomHeight > 0) Padding(padding: EdgeInsets.only(bottom: bottomHeight)),
      ],
    );
  }
}

class _ExpandedTitleWithPadding extends SingleChildRenderObjectWidget {
  const _ExpandedTitleWithPadding({
    required this.padding,
    required this.maxExtent,
    super.child,
  });

  final EdgeInsetsGeometry padding;
  final double maxExtent;

  @override
  _RenderExpandedTitleBox createRenderObject(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    return _RenderExpandedTitleBox(
      padding.resolve(textDirection),
      AlignmentDirectional.bottomStart.resolve(textDirection),
      maxExtent,
      null,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderExpandedTitleBox renderObject) {
    final TextDirection textDirection = Directionality.of(context);
    renderObject
      ..padding = padding.resolve(textDirection)
      ..titleAlignment = AlignmentDirectional.bottomStart.resolve(textDirection)
      ..maxExtent = maxExtent;
  }
}

class _MediumScrollUnderFlexibleConfig with _ScrollUnderFlexibleConfig {
  _MediumScrollUnderFlexibleConfig(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  static const double collapsedHeight = 48.0;
  static const double expandedHeight = 80.0;

  @override
  TextStyle? get collapsedTextStyle => _textTheme.titleLarge?.apply(color: _colors.onSurface);

  @override
  TextStyle? get expandedTextStyle => _textTheme.headlineSmall?.apply(color: _colors.onSurface);

  @override
  EdgeInsetsGeometry get expandedTitlePadding => const EdgeInsets.fromLTRB(16, 0, 16, 20);
}

mixin _ScrollUnderFlexibleConfig {
  TextStyle? get collapsedTextStyle;
  TextStyle? get expandedTextStyle;
  EdgeInsetsGeometry get expandedTitlePadding;
}

class _RenderExpandedTitleBox extends RenderShiftedBox {
  _RenderExpandedTitleBox(this._padding, this._titleAlignment, this._maxExtent, super.child);

  EdgeInsets get padding => _padding;
  EdgeInsets _padding;
  set padding(EdgeInsets value) {
    if (_padding == value) {
      return;
    }
    assert(value.isNonNegative);
    _padding = value;
    markNeedsLayout();
  }

  Alignment get titleAlignment => _titleAlignment;
  Alignment _titleAlignment;
  set titleAlignment(Alignment value) {
    if (_titleAlignment == value) {
      return;
    }
    _titleAlignment = value;
    markNeedsLayout();
  }

  double get maxExtent => _maxExtent;
  double _maxExtent;
  set maxExtent(double value) {
    if (_maxExtent == value) {
      return;
    }
    _maxExtent = value;
    markNeedsLayout();
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final RenderBox? child = this.child;
    return child == null
        ? 0.0
        : child.getMaxIntrinsicHeight(math.max(0, width - padding.horizontal)) + padding.vertical;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final RenderBox? child = this.child;
    return child == null ? 0.0 : child.getMaxIntrinsicWidth(double.infinity) + padding.horizontal;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final RenderBox? child = this.child;
    return child == null
        ? 0.0
        : child.getMinIntrinsicHeight(math.max(0, width - padding.horizontal)) + padding.vertical;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final RenderBox? child = this.child;
    return child == null ? 0.0 : child.getMinIntrinsicWidth(double.infinity) + padding.horizontal;
  }

  Size _computeSize(BoxConstraints constraints, ChildLayouter layoutChild) {
    final RenderBox? child = this.child;
    if (child == null) {
      return Size.zero;
    }
    layoutChild(child, constraints.widthConstraints().deflate(padding));
    return constraints.biggest;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _computeSize(constraints, ChildLayoutHelper.dryLayoutChild);

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      this.size = constraints.smallest;
      return;
    }
    final Size size = this.size = _computeSize(constraints, ChildLayoutHelper.layoutChild);
    final Size childSize = child.size;

    assert(padding.isNonNegative);
    assert(titleAlignment.y == 1.0);
    // yAdjustement is the minimum additional y offset to shift the child in
    // the visible vertical space when AppBar is fully expanded. The goal is to
    // prevent the expanded title from being clipped when the expanded title
    // widget + the bottom padding is too tall to fit in the flexible space (the
    // top padding is basically ignored since the expanded title is
    // bottom-aligned).
    final double yAdjustement = clampDouble(childSize.height + padding.bottom - maxExtent, 0, padding.bottom);
    final double offsetY = size.height - childSize.height - padding.bottom + yAdjustement;
    final double offsetX =
        (titleAlignment.x + 1) / 2 * (size.width - padding.horizontal - childSize.width) + padding.left;

    final BoxParentData childParentData = child.parentData! as BoxParentData;
    childParentData.offset = Offset(offsetX, offsetY);
  }
}
