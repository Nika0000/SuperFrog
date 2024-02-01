import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/theme_provider.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Demo App',
      theme: ThemeProvider.light,
      darkTheme: ThemeProvider.dark,
      themeMode: context.watch<ThemeProvider>().state,
      routerConfig: AppRoutes.router,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: CommonBloc.authenticationBloc..add(const AuthenticationEvent.start()),
          listener: (context, authState) => authState.whenOrNull(
            authenticated: (user) => AppRoutes.router.replaceNamed(AppRoutes.HOME),
            unAuthenticated: () => AppRoutes.router.replaceNamed(AppRoutes.SIGNIN),
          ),
          child: child,
        );
      },
    );
  }
}
