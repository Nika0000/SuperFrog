import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: CommonBloc.authenticationBloc,
          builder: (context, authState) {
            return authState.maybeWhen(
              authenticated: (user) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.userMetadata!['avatar_url'],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(user?.userMetadata!['name'] ?? 'Undefined'),
                  const SizedBox(height: 8.0),
                  Text(user?.userMetadata!['email'] ?? 'Undefined'),
                  const SizedBox(height: 16.0),
                  MoonFilledButton(
                    onTap: () => CommonBloc.authenticationBloc.add(const AuthenticationEvent.signOut()),
                    label: const Text('Sign out'),
                  )
                ],
              ),
              orElse: () => Container(),
            );
          },
        ),
      ),
    );
  }
}
