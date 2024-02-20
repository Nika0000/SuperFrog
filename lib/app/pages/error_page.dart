import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class ErrorPage extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget>? actions;

  const ErrorPage({
    this.title = 'Somethin wrong here...',
    this.description = 'We`re having technical issues (as you can see)\nTry to refresh the page now or later',
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MoonIcon(
              MoonIcons.generic_settings_32_light,
              size: 80.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: MoonTypography.typography.heading.text24,
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: MoonTypography.typography.body.text16,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            if (actions != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: actions!,
              )
          ],
        ),
      ),
    );
  }
}
