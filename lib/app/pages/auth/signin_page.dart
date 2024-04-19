import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/text_divider.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/form_validation.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
            AuthenticationEvent.signInWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: CommonBloc.authenticationBloc,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: MoonTypography.typography.heading.text24,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Sign in to your account',
                style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 32.0),
              MoonOutlinedButton(
                borderColor: context.moonColors?.beerus,
                onTap: () {
                  context.read<AuthenticationBloc>().add(const AuthenticationEvent.signInWithGoogle());
                },
                leading: SvgPicture.asset(
                  'assets/images/logo_google.svg',
                  height: 24,
                  width: 24,
                ),
                isFullWidth: true,
                label: const Text('Continue with Google'),
              ),
              const SizedBox(height: 16.0),
              MoonOutlinedButton(
                borderColor: context.moonColors?.beerus,
                onTap: () {},
                leading: const Icon(MoonIcons.other_lightning_24_light),
                isFullWidth: true,
                label: const Text('Send me a Magic Link'),
              ),
              const SizedBox(height: 16.0),
              const TextDivider(text: 'or'),
              const SizedBox(height: 16.0),
              Text(
                'Email',
                style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
              ),
              const SizedBox(height: 8.0),
              MoonFormTextInput(
                controller: _emailController,
                textInputSize: MoonTextInputSize.md,
                hintText: 'you@example.com',
                enabled: state.whenOrNull(loading: () => false),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => FormValidation.email(email),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Password',
                    style: MoonTypography.typography.heading.text14.copyWith(
                      color: context.moonColors?.trunks,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed(AppPages.RECOVERY.name),
                    child: Text(
                      'Forgot Password?',
                      style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              MoonFormTextInput(
                controller: _passwordController,
                textInputSize: MoonTextInputSize.md,
                obscureText: true,
                hintText: 'password',
                obscuringCharacter: '●',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: state.whenOrNull(loading: () => false),
                validator: (password) => FormValidation.password(password),
                onSubmitted: (_) => _submitForm(),
              ),
              const SizedBox(height: 48.0),
              MoonFilledButton(
                isFullWidth: true,
                onTap: state.maybeWhen(
                  loading: () => null,
                  orElse: () => _submitForm,
                ),
                label: state.maybeWhen(
                  loading: () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10.0,
                        width: 10.0,
                        child: MoonCircularLoader(
                          color: context.moonColors?.goten,
                          circularLoaderSize: MoonCircularLoaderSize.x2s,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text('Sign In')
                    ],
                  ),
                  orElse: () => const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don`t have an account?',
                    style: MoonTypography.typography.body.text14.copyWith(
                      color: context.moonColors?.trunks,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => context.goNamed(AppPages.SIGN_UP.name),
                    child: Text(
                      'Sign Up Now',
                      style: MoonTypography.typography.heading.text14.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              /* Text(
                'By continuing, you agree to AppName`s Terms of Service and Privacy Policy, and to receive periodic emails with updates.',
                textAlign: TextAlign.center,
                style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
              ) */
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
