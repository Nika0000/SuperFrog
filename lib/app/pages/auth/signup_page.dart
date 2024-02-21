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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
            AuthenticationEvent.signUpWithPassword(
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
                'Get started',
                style: MoonTypography.typography.heading.text24,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Create a new account',
                style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 32.0),
              MoonButton(
                showBorder: true,
                backgroundColor: context.moonColors?.gohan,
                borderColor: context.moonColors?.beerus,
                onTap: () {},
                leading: SvgPicture.asset(
                  'assets/images/logo_google.svg',
                  height: 24,
                  width: 24,
                ),
                isFullWidth: true,
                label: const Text('Continue with Google'),
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
                onTap: () {},
                controller: _emailController,
                textInputSize: MoonTextInputSize.md,
                hintText: 'you@example.com',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: state.whenOrNull(loading: () => false),
                validator: (email) => FormValidation.email(email),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Password',
                style: MoonTypography.typography.heading.text14.copyWith(
                  color: context.moonColors?.trunks,
                ),
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
                          color: context.moonColors?.textPrimary,
                          circularLoaderSize: MoonCircularLoaderSize.x2s,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text('Sign Up')
                    ],
                  ),
                  orElse: () => const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have an account?',
                    style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => context.goNamed(AppPages.SIGN_IN.name),
                    child: Text(
                      'Sign In Now',
                      style: MoonTypography.typography.heading.text14.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
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
