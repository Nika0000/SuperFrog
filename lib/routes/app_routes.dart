// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superfrog/app/pages/auth/auth_page.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/app/pages/home_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String HOME = 'home';
  static const String PROFILE = 'profile';

  static const String SIGNIN = 'signin';
  static const String SIGNUP = 'signup';

  static GoRouter router = GoRouter(
    initialLocation: '/home',
    errorBuilder: (_, state) => ErrorPage(state: state),
    routes: [
      GoRoute(
        name: HOME,
        path: '/home',
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (_, __) => Container(),
        routes: [
          GoRoute(
            name: SIGNIN,
            path: 'signin',
            builder: (_, __) => const AuthPage(AuthPageRoutes.SIGNIN),
          ),
          GoRoute(
            name: SIGNUP,
            path: 'signup',
            builder: (_, __) => const AuthPage(AuthPageRoutes.SIGNUP),
          ),
          GoRoute(
            path: 'oauth/callback',
            builder: (_, state) => OAuthCallBack(url: state.uri),
          )
        ],
      ),
    ],
  );
}
