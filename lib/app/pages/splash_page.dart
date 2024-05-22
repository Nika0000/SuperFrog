import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/utils/extensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _opacityTimer;
  late Timer _alertTimer;

  bool _showAlert = false;

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
      setState(() {
        _showAlert = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
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
        ),
        Align(
          alignment: context.responsiveWhen(Alignment.topRight, sm: Alignment.bottomCenter),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.maxFinite)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(
                bottom: MediaQuery.paddingOf(context).bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showAlert)
                    MoonAlert(
                      show: _showAlert,
                      showBorder: true,
                      borderColor: context.moonColors?.beerus,
                      color: context.moonColors?.trunks,
                      backgroundColor: context.moonColors?.gohan,
                      leading: const Icon(MoonIcons.generic_alarm_24_light),
                      label: const Text(
                        'Loading is taking longer then normal. Plsease be patient and ensure that you have a strong & stabile internet connection.',
                      ),
                      trailing: MoonButton.icon(
                        buttonSize: MoonButtonSize.xs,
                        onTap: () => setState(() {
                          _showAlert = false;
                        }),
                        icon: Icon(
                          MoonIcons.controls_close_24_light,
                          color: context.moonColors?.trunks,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _opacityTimer.cancel();
    _alertTimer.cancel();
    super.dispose();
  }
}
