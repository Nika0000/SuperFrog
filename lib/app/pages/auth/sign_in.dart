import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/app/widgets/moon_appbar.dart';
import 'package:superfrog/app/widgets/text_divider.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          MoonAppBar(
            title: const Text('Sign In'),
            expandedTextStyle: MoonTypography.typography.heading.text32,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Don`t have an account?',
                        style: MoonTypography.typography.body.text16,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Create Account',
                        style: MoonTypography.typography.heading.text16.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  MoonTextInputGroup(
                    backgroundColor: context.moonColors?.gohan,
                    children: <MoonFormTextInput>[
                      MoonFormTextInput(
                        controller: _emailController,
                        hasFloatingLabel: true,
                        textInputSize: MoonTextInputSize.lg,
                        hintText: 'Email adress',
                      ),
                      MoonFormTextInput(
                        controller: _passwordController,
                        hasFloatingLabel: true,
                        textInputSize: MoonTextInputSize.lg,
                        hintText: 'Password',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Forgot Password?',
                    style: MoonTypography.typography.heading.text16.copyWith(decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 16.0),
                  MoonFilledButton(
                    isFullWidth: true,
                    buttonSize: MoonButtonSize.lg,
                    label: const Text('Sign In'),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      CommonBloc.authenticationBloc.add(
                        AuthenticationEvent.signInWithPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24.0),
                  const TextDivider(text: 'Or'),
                  const SizedBox(height: 24.0),
                  MoonOutlinedButton(
                    isFullWidth: true,
                    buttonSize: MoonButtonSize.lg,
                    label: const Text('Continue with Google'),
                    onTap: kIsWeb
                        ? () {
                            Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
