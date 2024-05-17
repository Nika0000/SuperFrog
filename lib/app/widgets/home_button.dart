import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/home'),
        child: switch (Theme.of(context).brightness) {
          Brightness.light => SvgPicture.asset(
              'assets/images/logo_dark.svg',
              height: 24.0,
            ),
          Brightness.dark => SvgPicture.asset(
              'assets/images/logo_light.svg',
              height: 24.0,
            ),
        },
      ),
    );
  }
}
