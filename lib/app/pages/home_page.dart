import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/splash_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/utils/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: CommonBloc.authenticationBloc,
          builder: (context, state) {
            return state.maybeWhen(
              authenticated: (user) => Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.responsiveWhen(480, sm: double.maxFinite),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.moonColors!.beerus),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ID',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user!.id),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Provider',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user.identities![0].provider),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Email',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user.email!),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Last signed in',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user.lastSignInAt!),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        MoonFilledButton(
                          isFullWidth: true,
                          onTap: () => context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut()),
                          label: const Text('Sign Out'),
                        ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                ),
              ),
              orElse: () => const SplashPage(),
            );
          },
        ),
      ),
    );
  }
}
