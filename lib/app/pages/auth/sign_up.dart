import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/moon_appbar.dart';
import 'package:superfrog/app/widgets/text_divider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          MoonAppBar(
            title: const Text('Create Account'),
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
                        'Already have an account?',
                        style: MoonTypography.typography.body.text16,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Log in',
                        style: MoonTypography.typography.heading.text16.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  MoonTextInputGroup(
                    backgroundColor: context.moonColors?.gohan,
                    helper: const Text('The name must match the details on the ID'),
                    children: <MoonFormTextInput>[
                      MoonFormTextInput(
                        hasFloatingLabel: true,
                        textInputSize: MoonTextInputSize.lg,
                        hintText: 'Username',
                      ),
                      MoonFormTextInput(
                        hasFloatingLabel: true,
                        textInputSize: MoonTextInputSize.lg,
                        hintText: 'Email address',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  MoonFormTextInput(
                    hasFloatingLabel: true,
                    textInputSize: MoonTextInputSize.lg,
                    backgroundColor: context.moonColors?.gohan,
                    hintText: 'Date of birth',
                    helper: const Text('The minimum age for registration is 18 years old'),
                  ),
                  const SizedBox(height: 24.0),
                  MoonTextInputGroup(
                    backgroundColor: context.moonColors?.gohan,
                    helper: const Text('The name must match the details on the ID'),
                    children: <MoonFormTextInput>[
                      MoonFormTextInput(
                        hasFloatingLabel: true,
                        textInputSize: MoonTextInputSize.lg,
                        hintText: 'Username',
                      ),
                      MoonFormTextInput(
                        hasFloatingLabel: true,
                        textInputSize: MoonTextInputSize.lg,
                        hintText: 'Email address',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  MoonFormTextInput(
                    hasFloatingLabel: true,
                    textInputSize: MoonTextInputSize.lg,
                    backgroundColor: context.moonColors?.gohan,
                    hintText: 'Password',
                    helper: const Text(
                      'Password must be at last 8 characters. Can`t include your name or email address',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  MoonFilledButton(
                    isFullWidth: true,
                    buttonSize: MoonButtonSize.lg,
                    label: const Text('Agree and continue'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 24.0),
                  const TextDivider(text: 'Or'),
                  const SizedBox(height: 24.0),
                  MoonOutlinedButton(
                    isFullWidth: true,
                    buttonSize: MoonButtonSize.lg,
                    leading: const Icon(Icons.facebook_rounded),
                    label: const Text('Continue with Google'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  MoonOutlinedButton(
                    isFullWidth: true,
                    buttonSize: MoonButtonSize.lg,
                    leading: const Icon(Icons.facebook_rounded),
                    label: const Text('Continue with Facebook'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  MoonOutlinedButton(
                    isFullWidth: true,
                    buttonSize: MoonButtonSize.lg,
                    leading: const Icon(Icons.g_mobiledata),
                    label: const Text('Continue with Github'),
                    onTap: () {},
                  ),
                  SizedBox(height: 32 + MediaQuery.paddingOf(context).bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
