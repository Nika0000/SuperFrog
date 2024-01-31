// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/sign_in.dart';
import 'package:superfrog/app/pages/auth/sign_up.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';

class AuthPage extends StatefulWidget {
  final AuthPageRoutes route;
  const AuthPage(this.route, {super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: CommonBloc.authenticationBloc,
        listener: (context, authState) => authState.whenOrNull(error: (error) {
          MoonToast.clearToastQueue();
          return MoonToast.show(context, label: Text(error));
        }),
        child: switch (widget.route) {
          AuthPageRoutes.SIGNIN => const SignInPage(),
          AuthPageRoutes.SIGNUP => const SignUpPage()
        },
      ),
    );
  }
}

enum AuthPageRoutes {
  SIGNIN,
  SIGNUP,
}

class OAuthCallBack extends StatelessWidget {
  final Uri url;
  const OAuthCallBack({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              CommonBloc.authenticationBloc.add(AuthenticationEvent.verifySession(url));
            },
            child: const Text('Verify Session'),
          ),
        ],
      ),
    );
  }
}
