// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      body: SafeArea(
        child: switch (widget.route) {
          AuthPageRoutes.SIGNIN => Center(
              child: MoonFilledButton(
                onTap: () {
                  Supabase.instance.client.auth.signInWithOAuth(
                    OAuthProvider.google,
                    redirectTo: kIsWeb ? 'http://localhost:8080/auth/oauth/callback' : 'myapp://auth/callback',
                  );
                },
                label: const Text('Continue with Google'),
              ),
            ),
          AuthPageRoutes.SIGNUP => const Center(child: Text('SignUp')),
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
