import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/utils/extensions.dart';

class AlertNotification {
  AlertNotification._();

  static show(
    BuildContext context, {
    required Widget label,
    Widget? content,
    Duration? displayDuration,
    required AlertVariant variant,
  }) {
    final Color? foregroundColor = switch (variant) {
      AlertVariant.success => context.moonColors?.roshi,
      AlertVariant.error => context.moonColors?.dodoria,
      AlertVariant.warning => context.moonColors?.krillin,
      _ => Colors.transparent,
    };

    final Color? backgroundColor = switch (variant) {
      AlertVariant.success => context.moonColors?.roshi10,
      AlertVariant.error => context.moonColors?.dodoria10,
      AlertVariant.warning => context.moonColors?.krillin10,
      _ => Colors.transparent,
    };

    final IconData alertIcon = switch (variant) {
      AlertVariant.success => MoonIcons.generic_check_rounded_24_regular,
      AlertVariant.error => MoonIcons.generic_alarm_round_24_regular,
      AlertVariant.warning => MoonIcons.generic_alarm_24_regular,
      _ => MoonIcons.arrows_left_short_16_regular,
    };

    final double width = context.responsiveWhen(400, sm: double.maxFinite);
    final Alignment alignment = context.responsiveWhen(Alignment.topRight, sm: Alignment.bottomCenter);

    return MoonToast.show(
      context,
      content: content,
      width: width,
      toastAlignment: alignment,
      displayDuration: displayDuration,
      leading: Container(
        height: 32.0,
        width: 32.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: MoonSquircleBorderRadius(cornerRadius: 8.0),
        ),
        child: Icon(
          alertIcon,
          color: foregroundColor,
        ),
      ),
      label: Row(
        children: [
          Expanded(child: label),
        ],
      ),
      trailing: MoonButton.icon(
        buttonSize: MoonButtonSize.sm,
        icon: const Icon(MoonIcons.controls_close_small_16_light),
        onTap: () => MoonToast.clearToastQueue(),
      ),
      toastShadows: context.moonShadows?.sm,
    );
  }
}

enum AlertVariant { success, error, warning, info }
