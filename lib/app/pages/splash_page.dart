import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:rive/rive.dart';
import 'package:superfrog/app/widgets/alert_notification.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _alertTimer;

  @override
  void initState() {
    _alertTimer = Timer(const Duration(seconds: 10), () {
      AlertNotification.show(
        context,
        variant: AlertVariant.warning,
        displayDuration: const Duration(seconds: 16),
        label: const Text(
          'Loading is taking longer then normal. Plsease be patient and ensure that you have a strong & stabile internet connection.',
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 32.0,
        height: 32.0,
        child: RiveAnimation.asset(
          'assets/animations/logo_small.riv',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alertTimer.cancel();
    MoonToast.clearToastQueue();
    super.dispose();
  }
}
