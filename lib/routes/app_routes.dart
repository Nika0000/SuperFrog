// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/auth_page.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/app/pages/main_page.dart';

enum AppRoutes {
  HOME(path: '/home', name: 'home'),

  PROFILE(path: '/profile', name: 'profile'),

  AUTH(path: '/auth', name: 'auth'),

  SIGN_IN(path: '/signin', name: 'signin'),

  SIGN_UP(path: '/signup', name: 'signup'),

  RECOVERY(path: '/recovery', name: 'recovery'),

  UPDATE_PASSWORD(path: 'update-password', name: 'update-password');

  final String path;
  final String name;
  const AppRoutes({required this.path, required this.name});
}

class PageRouter {
  const PageRouter._();

  static GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.HOME.path,
    errorBuilder: (BuildContext context, __) => ErrorPage(
      title: '404 - PAGE NOT FOUND',
      description:
          'The page you are looking for might have been removed\nhad its name changed or it temorarily unvailable.',
      actions: [
        MoonOutlinedButton(
          onTap: () => context.pushReplacementNamed(AppRoutes.HOME.name),
          label: const Text('Go Back'),
        )
      ],
    ),
    routes: [
      GoRoute(
        name: AppRoutes.HOME.name,
        path: AppRoutes.HOME.path,
        builder: (_, __) => const MainPage(MainPageRoutes.HOME),
      ),
      GoRoute(
        path: AppRoutes.AUTH.path,
        builder: (_, __) => Container(),
        routes: [
          GoRoute(
            name: AppRoutes.SIGN_IN.name,
            path: 'signin',
            builder: (_, __) => const AuthPage(AuthPageRoutes.SIGNIN),
          ),
          GoRoute(
            name: AppRoutes.SIGN_UP.name,
            path: 'signup',
            builder: (_, __) => const AuthPage(AuthPageRoutes.SIGNUP),
          ),
          GoRoute(
            name: AppRoutes.RECOVERY.name,
            path: 'forgot-password',
            builder: (_, __) => const AuthPage(AuthPageRoutes.RECOVERY),
          ),
          GoRoute(
            name: AppRoutes.UPDATE_PASSWORD.name,
            path: 'update-password',
            builder: (_, __) => const AuthPage(AuthPageRoutes.UPDATE_PASSWORD),
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
