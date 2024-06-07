// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/auth_page.dart';
import 'package:superfrog/app/pages/auth/callback_page.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/app/pages/main_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/utils/navigation_key.dart';

enum AppPages {
  //GENERIC
  HOME(path: '/home', name: 'home', pathFull: '/home'),
  STORAGE(path: 'storage', name: 'storage', pathFull: '/home/storage'),
  SETTINGS(path: 'settings', name: 'settings', pathFull: '/home/settings'),
  WEBSOCKET(path: 'ws', name: 'ws', pathFull: '/home/ws'),
  //USER
  PROFILE(path: '/profile', name: 'profile'),
  //AUTH
  AUTH(path: '/auth', name: 'auth'),
  SIGN_IN(path: 'signin', name: 'signin', pathFull: '/auth/signin'),
  SIGN_UP(path: 'signup', name: 'signup', pathFull: '/auth/signup'),
  RECOVERY(path: 'recovery', name: 'recovery', pathFull: '/auth/recovery'),

  AUTH_CALLBACK(path: 'callback/verify', name: 'callback');

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
    navigatorKey: GetIt.I<NavigationKeySingleton>().key,
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
        routes: [
          GoRoute(
            name: AppPages.STORAGE.name,
            path: AppPages.STORAGE.path,
            builder: (_, __) => const MainPage(MainPageRoutes.STORAGE),
          ),
          GoRoute(
            name: AppPages.SETTINGS.name,
            path: AppPages.SETTINGS.path,
            builder: (_, __) => const MainPage(MainPageRoutes.SETTINGS),
          ),
          GoRoute(
            name: AppPages.WEBSOCKET.name,
            path: AppPages.WEBSOCKET.path,
            builder: (_, __) => const MainPage(MainPageRoutes.WEBSOCKET),
          ),
        ],
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
            path: AppPages.AUTH_CALLBACK.path,
            name: AppPages.AUTH_CALLBACK.name,
            builder: (context, state) {
              final String? token = state.uri.queryParameters['token'];
              final String? type = state.uri.queryParameters['type'];
              final metaData = state.extra as Map<String, dynamic>?;
              return AuthCallBackPage(
                token: token,
                type: type,
                metadata: metaData,
              );
            },
          ),
        ],
      ),
    ],
  );
}
