// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/app/pages/auth/recovery_page.dart';
import 'package:superfrog/app/pages/auth/signin_page.dart';
import 'package:superfrog/app/pages/auth/signup_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/theme_provider.dart';

class AuthPage extends StatefulWidget {
  final AuthPageRoutes route;
  const AuthPage(this.route, {super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: CommonBloc.authenticationBloc,
      listener: (context, state) {
        state.whenOrNull(
          error: (error) {
            return MoonToast.show(
              context,
              toastShadows: context.moonShadows?.sm,
              label: Text(error),
              leading: const MoonIcon(MoonIcons.generic_alarm_24_light),
            );
          },
          message: (message) {
            return MoonToast.show(
              context,
              toastShadows: context.moonShadows?.sm,
              leading: const MoonIcon(MoonIcons.generic_check_rounded_24_light),
              label: Text(message),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: context.moonColors?.gohan,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.moonColors?.gohan,
          //shape: const Border(),
          title: SvgPicture.asset(
            context.read<ThemeProvider>().state == ThemeMode.dark
                ? 'assets/images/logo_light.svg'
                : 'assets/images/logo_dark.svg',
            height: 24.0,
          ),
        ),
        body: Align(
          alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.infinity)),
              child: switch (widget.route) {
                AuthPageRoutes.SIGNIN => const SignInPage(),
                AuthPageRoutes.SIGNUP => const SignUpPage(),
                AuthPageRoutes.RECOVERY => const RecoveryPage(),
                AuthPageRoutes.UPDATE_PASSWORD => OAuthCallBack(url: Uri()),
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthPageRoutes { SIGNIN, SIGNUP, RECOVERY, UPDATE_PASSWORD }

class OAuthCallBack extends StatelessWidget {
  final Uri url;
  final OtpType? otpType;
  const OAuthCallBack({required this.url, this.otpType = OtpType.recovery, super.key});

  @override
  Widget build(BuildContext context) {
    return switch (otpType) {
      OtpType.recovery => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style: MoonTypography.typography.heading.text24,
            ),
            const SizedBox(height: 16.0),
            MoonAlert.filled(
              show: true,
              color: context.moonColors?.krillin,
              backgroundColor: context.moonColors?.krillin10,
              leading: const MoonIcon(MoonIcons.generic_alarm_24_light),
              label: const Text(
                'For security purposes, after resetting your password, the withdrawal function will be suspended for 24 hours.',
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              'New Password',
              style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
            ),
            const SizedBox(height: 8.0),
            MoonFormTextInput(
              textInputSize: MoonTextInputSize.md,
              hintText: 'password',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Confirm Password',
              style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
            ),
            const SizedBox(height: 8.0),
            MoonFormTextInput(
              textInputSize: MoonTextInputSize.md,
              hintText: 'password',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Verification Code',
              style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
            ),
            const SizedBox(height: 8.0),
            MoonFormTextInput(
              hintText: 'verification code',
              trailing: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MoonButton(
                  label: const Text('Resent'),
                  showBorder: true,
                  textColor: context.moonColors?.textSecondary,
                  buttonSize: MoonButtonSize.xs,
                  borderColor: context.moonColors?.beerus,
                  onTap: () {},
                ),
              ),
            ),
            const SizedBox(height: 48.0),
            MoonFilledButton(
              isFullWidth: true,
              onTap: () {},
              label: const Text('Update Password'),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account?',
                  style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () => context.replaceNamed(AppPages.SIGN_IN.name),
                  child: Text(
                    'Sign In Now',
                    style: MoonTypography.typography.heading.text14.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      _ => const Text('_')
    };
  }
}
