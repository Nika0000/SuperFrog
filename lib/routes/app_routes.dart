// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/auth_page.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/app/pages/main_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';

enum AppPages {
  HOME(path: '/home', name: 'home', pathFull: '/home'),
  PROFILE(path: '/profile', name: 'profile'),
  AUTH(path: '/auth', name: 'auth'),
  SIGN_IN(path: 'signin', name: 'signin', pathFull: '/auth/signin'),
  SIGN_UP(path: 'signup', name: 'signup', pathFull: '/auth/signup'),
  RECOVERY(path: 'recovery', name: 'recovery', pathFull: '/auth/recovery'),
  UPDATE_PASSWORD(path: 'update-password', name: 'update-password', pathFull: '/auth/update-password');

  final String path;
  final String name;
  final String? pathFull;
  const AppPages({
    required this.path,
    required this.name,
    this.pathFull,
  });
}

class AppRouter {
  const AppRouter._();

  static GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppPages.HOME.path,
    errorBuilder: (BuildContext context, __) => ErrorPage(
      title: '404 - PAGE NOT FOUND',
      description:
          'The page you are looking for might have been removed\nhad its name changed or it temorarily unvailable.',
      actions: [
        MoonOutlinedButton(
          onTap: () => context.goNamed(AppPages.HOME.name),
          label: const Text('Go Back'),
        )
      ],
    ),
    routes: [
      GoRoute(
        name: AppPages.HOME.name,
        path: AppPages.HOME.path,
        builder: (_, __) => const MainPage(MainPageRoutes.HOME),
        redirect: (BuildContext context, GoRouterState state) {
          final AuthenticationState authState = context.read<AuthenticationBloc>().state;

          return authState.whenOrNull(unAuthenticated: () => AppPages.SIGN_IN.pathFull);
        },
      ),
      GoRoute(
        path: AppPages.AUTH.path,
        redirect: (BuildContext context, GoRouterState state) {
          final AuthenticationState authState = context.read<AuthenticationBloc>().state;
          return authState.whenOrNull(authenticated: (_) => AppPages.HOME.pathFull);
        },
        routes: [
          GoRoute(
            name: AppPages.SIGN_IN.name,
            path: AppPages.SIGN_IN.path,
            builder: (_, __) => const AuthPage(AuthPageRoutes.SIGNIN),
          ),
          GoRoute(
            name: AppPages.SIGN_UP.name,
            path: AppPages.SIGN_UP.path,
            builder: (_, __) => const AuthPage(AuthPageRoutes.SIGNUP),
          ),
          GoRoute(
            name: AppPages.RECOVERY.name,
            path: AppPages.RECOVERY.path,
            builder: (_, __) => const AuthPage(AuthPageRoutes.RECOVERY),
          ),
          GoRoute(
            name: AppPages.UPDATE_PASSWORD.name,
            path: AppPages.UPDATE_PASSWORD.path,
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
