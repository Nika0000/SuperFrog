import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/alert_notification.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _opacityTimer;
  late Timer _alertTimer;

  double _opacityValue = 1.0;

  @override
  void initState() {
    _opacityTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(() {
          _opacityValue != 1.0 ? _opacityValue = 1.0 : _opacityValue = .5;
        });
      },
    );

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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _opacityValue,
            duration: const Duration(milliseconds: 250),
            child: SvgPicture.asset(
              'assets/images/logo_small.svg',
              width: 64.0,
              height: 64.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _opacityTimer.cancel();
    _alertTimer.cancel();
    MoonToast.clearToastQueue();
    super.dispose();
  }
}
