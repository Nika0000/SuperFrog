import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';

class CaptchaDialog extends StatefulWidget {
  const CaptchaDialog({super.key});

  @override
  State<CaptchaDialog> createState() => _CaptchaDialogState();
}

class _CaptchaDialogState extends State<CaptchaDialog> {
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    Color? adaptiveColorPrimary = isVerified ? context.moonColors?.cell : context.moonColors?.krillin;
    Color? adaptiveColorSecondary = isVerified ? context.moonColors?.cell10 : context.moonColors?.krillin10;

    return MoonModal(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: adaptiveColorSecondary,
                      ),
                      child: Icon(
                        MoonIcons.security_shield_secured_32_light,
                        color: adaptiveColorPrimary,
                        size: 48.0,
                      ),
                    ),
                    if (!isVerified)
                      MoonCircularLoader(
                        strokeWidth: 2,
                        color: adaptiveColorPrimary,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Verifing you are human.',
                style: MoonTypography.typography.body.text14,
              ),
              const SizedBox(height: 4.0),
              Text(
                'This may take a few secounds.',
                style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.textSecondary),
              ),
              CloudFlareTurnstile(
                siteKey: const String.fromEnvironment("TURNSTILE_SITE_KEY"),
                options: TurnstileOptions(mode: TurnstileMode.invisible),
                onError: (error) {
                  print('error $error');
                  context.pop();
                },
                onTokenRecived: (token) async {
                  context.pop(token);
                  setState(() {
                    isVerified = true;
                  });
                  Future.delayed(const Duration(seconds: 1));

                  if (mounted) return;
                  context.pop(token);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
