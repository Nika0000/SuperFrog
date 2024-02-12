// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/recovery_page.dart';
import 'package:superfrog/app/pages/auth/signin_page.dart';
import 'package:superfrog/app/pages/auth/signup_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
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
              label: Text(error),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: context.moonColors?.gohan,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.moonColors?.gohan,
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
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthPageRoutes { SIGNIN, SIGNUP, RECOVERY }

class OAuthCallBack extends StatelessWidget {
  final Uri url;
  const OAuthCallBack({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                CommonBloc.authenticationBloc.add(AuthenticationEvent.verifySession(url));
              },
              child: const Text('Verify Session'),
            ),
          ],
        ),
      ),
    );
  }
}
