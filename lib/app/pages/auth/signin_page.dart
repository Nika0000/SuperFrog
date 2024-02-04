import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/text_divider.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: MoonTypography.typography.heading.text32,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Sign in to your account',
                style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
              ),
              const SizedBox(height: 32.0),
              MoonOutlinedButton(
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
              MoonOutlinedButton(
                onTap: () {},
                leading: const MoonIcon(MoonIcons.security_lock_24_regular),
                isFullWidth: true,
                label: const Text('Continue with SSO'),
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
                //          controller: _emailController,
                textInputSize: MoonTextInputSize.md,
                hintText: 'you@example.com',
                textInputAction: TextInputAction.next,
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
                    onTap: () => context.goNamed(AppRoutes.RECOVERY),
                    child: Text(
                      'Forgot Password?',
                      style: MoonTypography.typography.heading.text14.copyWith(
                        color: context.moonColors?.trunks,
                        //  decoration: TextDecoration.underline,
                        decorationColor: context.moonColors?.trunks,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              MoonFormTextInput(
                textInputSize: MoonTextInputSize.md,
                obscureText: true,
                hintText: 'password',
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => FormValidation.password(password),
                onSubmitted: (_) => _submitForm(),
              ),
              const SizedBox(height: 48.0),
              MoonFilledButton(
                isFullWidth: true,
                onTap: _submitForm,
                label: const Text('Sign In'),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don`t have an account?',
                    style: MoonTypography.typography.body.text14,
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => context.replaceNamed(AppRoutes.SIGNUP),
                    child: Text(
                      'Sign Up Now',
                      style: MoonTypography.typography.heading.text14.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
