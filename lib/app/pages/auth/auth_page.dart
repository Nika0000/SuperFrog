// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/recovery_page.dart';
import 'package:superfrog/app/pages/auth/signin_page.dart';
import 'package:superfrog/app/pages/auth/signup_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/form_validation.dart';

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
              leading: const Icon(MoonIcons.generic_alarm_24_light),
            );
          },
          message: (message) {
            return MoonToast.show(
              context,
              toastShadows: context.moonShadows?.sm,
              leading: const Icon(MoonIcons.generic_check_rounded_24_light),
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
          title: Theme.of(context).brightness == Brightness.light
              ? SvgPicture.asset(
                  'assets/images/logo_dark.svg',
                  height: 24.0,
                )
              : SvgPicture.asset(
                  'assets/images/logo_light.svg',
                  height: 24.0,
                ),
        ),
        body: Align(
          alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.maxFinite)),
              child: switch (widget.route) {
                AuthPageRoutes.SIGNIN => const SignInPage(),
                AuthPageRoutes.SIGNUP => const SignUpPage(),
                AuthPageRoutes.RECOVERY => const RecoveryPage(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthPageRoutes { SIGNIN, SIGNUP, RECOVERY }
