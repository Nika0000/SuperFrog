import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
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
      routerConfig: AppRouter.router,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      //themeAnimationStyle: AnimationStyle.noAnimation,
      supportedLocales: context.supportedLocales,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: GetIt.I.get<AuthenticationBloc>()..add(const AuthenticationEvent.start()),
          listener: (context, authState) => authState.whenOrNull(
            authenticated: (user) => AppRouter.router.refresh(),
            unAuthenticated: () => AppRouter.router.refresh(),
          ),
          child: child,
        );
      },
    );
  }
}
