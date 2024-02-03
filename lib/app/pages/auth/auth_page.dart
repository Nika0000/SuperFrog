// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/text_divider.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/theme_provider.dart';

class AuthPage extends StatefulWidget {
  final AuthPageRoutes route;
  const AuthPage(this.route, {super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    return switch (widget.route) {
      AuthPageRoutes.SIGNIN => context.read<AuthenticationBloc>().add(
            AuthenticationEvent.signInWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          ),
      AuthPageRoutes.SIGNUP => context.read<AuthenticationBloc>().add(
            AuthenticationEvent.signUpWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          )
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, authState) => authState.whenOrNull(
          error: (error) {
            MoonToast.clearToastQueue();
            return MoonToast.show(context, label: Text(error));
          },
        ),
        builder: (context, authState) => Scaffold(
          appBar: AppBar(
            backgroundColor: context.moonColors?.goku,
            title: SvgPicture.network(
              context.read<ThemeProvider>().state == ThemeMode.dark
                  ? 'https://cloudplay.b-cdn.net/assets/images/supabase-logo-wordmark--dark.svg'
                  : 'https://cloudplay.b-cdn.net/assets/images/supabase-logo-wordmark--light.svg',
              height: 24.0,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: authState.maybeWhen(
                loading: () => const MoonLinearLoader(
                  linearLoaderSize: MoonLinearLoaderSize.x6s,
                ),
                orElse: () => const SizedBox(),
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            switch (widget.route) {
                              AuthPageRoutes.SIGNIN => 'Welcome Back',
                              AuthPageRoutes.SIGNUP => 'Get started'
                            },
                            style: MoonTypography.typography.heading.text32,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            switch (widget.route) {
                              AuthPageRoutes.SIGNIN => 'Sign in to your account',
                              AuthPageRoutes.SIGNUP => 'Create a new account'
                            },
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
                            controller: _emailController,
                            textInputSize: MoonTextInputSize.md,
                            hintText: 'you@example.com',
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (email) => email.isNullOrEmpty ? 'Email is required' : null,
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
                              Text(
                                'Forgot Password?',
                                style: MoonTypography.typography.heading.text14.copyWith(
                                  color: context.moonColors?.trunks,
                                  //  decoration: TextDecoration.underline,
                                  decorationColor: context.moonColors?.trunks,
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
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (password) => password.isNullOrEmpty ? 'Password is required' : null,
                            onSubmitted: (_) => _submitForm(),
                          ),
                          const SizedBox(height: 48.0),
                          MoonFilledButton(
                            onTap: _submitForm,
                            isFullWidth: true,
                            label: Text(
                              switch (widget.route) {
                                AuthPageRoutes.SIGNIN => 'Sign In',
                                AuthPageRoutes.SIGNUP => 'Sign Up'
                              },
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                switch (widget.route) {
                                  AuthPageRoutes.SIGNIN => 'Don`t have an account?',
                                  AuthPageRoutes.SIGNUP => 'Have an account?'
                                },
                                style: MoonTypography.typography.body.text14,
                              ),
                              const SizedBox(width: 8.0),
                              GestureDetector(
                                onTap: () => context.replaceNamed(
                                  switch (widget.route) {
                                    AuthPageRoutes.SIGNIN => AppRoutes.SIGNUP,
                                    AuthPageRoutes.SIGNUP => AppRoutes.SIGNIN,
                                  },
                                ),
                                child: Text(
                                  switch (widget.route) {
                                    AuthPageRoutes.SIGNIN => 'Sign Up Now',
                                    AuthPageRoutes.SIGNUP => 'Sign In Now'
                                  },
                                  style: MoonTypography.typography.heading.text14.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Text(
                        'By continuing you agree to AppName`s Terms of Service and Privacy Policy, and to recive periodic emails and updates',
                        textAlign: TextAlign.center,
                        style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
                      ),
                    ],
                  ),
                ),
              ),
              authState.maybeWhen(
                loading: () => Container(
                  color: Colors.black.withOpacity(.5),
                ),
                orElse: () => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AuthPageRoutes {
  SIGNIN,
  SIGNUP,
}

class OAuthCallBack extends StatelessWidget {
  final Uri url;
  const OAuthCallBack({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              CommonBloc.authenticationBloc.add(AuthenticationEvent.verifySession(url));
            },
            child: const Text('Verify Session'),
          ),
        ],
      ),
    );
  }
}
