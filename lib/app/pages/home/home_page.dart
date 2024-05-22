import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.maybeWhen(
          authenticated: (user) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      MoonMenuItem(
                        backgroundColor: context.moonColors?.gohan,
                        label: const Text('UserID'),
                        trailing: SelectableText(user?.id ?? ''),
                        onTap: () {},
                      ),
                      const SizedBox(height: 8.0),
                      MoonMenuItem(
                        backgroundColor: context.moonColors?.gohan,
                        label: const Text('Email'),
                        trailing: SelectableText(user?.email ?? ''),
                        onTap: () {},
                      ),
                      const SizedBox(height: 8.0),
                      MoonAccordion(
                        expandedBackgroundColor: context.moonColors?.gohan,
                        backgroundColor: context.moonColors?.gohan,
                        shadows: const [],
                        label: const Text('Providers'),
                        children: List.generate(
                          user?.identities?.length ?? 0,
                          (index) => MoonMenuItem(
                            label: const Text('Provider'),
                            trailing: SelectableText(user!.identities![index].provider),
                            onTap: () {},
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      MoonFilledButton(
                        isFullWidth: true,
                        onTap: () {
                          context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut());
                        },
                        label: const Text('Sign Out'),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
            );
          },
          orElse: () => const ErrorPage(),
        );
      },
    );
  }
}
