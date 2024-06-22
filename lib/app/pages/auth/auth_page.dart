// ignore_for_file: constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/alert_notification.dart';
import 'package:superfrog/app/widgets/home_button.dart';
import 'package:superfrog/app/widgets/text_divider.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/captcha.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/form_validation.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';

class AuthPage extends StatefulWidget {
  final AuthPageRoutes route;
  const AuthPage(this.route, {super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TurnstileController _captchaController = TurnstileController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: GetIt.I.get<AuthenticationBloc>(),
      listener: (context, state) {
        state.whenOrNull(
          error: (error) {
            _captchaController.refreshToken();
            return AlertNotification.show(
              context,
              label: Text(error),
              variant: AlertVariant.error,
            );
          },
          message: (message) {
            return AlertNotification.show(
              context,
              label: Text(message),
              variant: AlertVariant.success,
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: context.moonColors?.gohan,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.moonColors?.gohan,
          //shape: const Border(),
          title: const HomeButton(),
        ),
        body: Align(
          alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.maxFinite)),
              child: Column(
                children: [
                  switch (widget.route) {
                    AuthPageRoutes.SIGNIN => const _SignInPage(),
                    AuthPageRoutes.SIGNUP => const _SignUpPage(),
                  },
                  CloudFlareTurnstile(
                    controller: _captchaController,
                    siteKey: const String.fromEnvironment('TURNSTILE_SITE_KEY'),
                    options: TurnstileOptions(mode: TurnstileMode.invisible),
                    onTokenRecived: (token) => Captcha.newToken = token,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// SignIn Page

class _SignInPage extends StatefulWidget {
  const _SignInPage();

  @override
  State<_SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<_SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _cMagicLink = false;
  bool _obscurePassword = true;

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_cMagicLink) {
        context.read<AuthenticationBloc>().add(
              AuthenticationEvent.signInWithMagicLink(
                email: _emailController.text.trim(),
              ),
            );
      } else {
        context.read<AuthenticationBloc>().add(
              AuthenticationEvent.signInWithPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: GetIt.I.get<AuthenticationBloc>(),
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'auth.sign_in.title'.tr(),
                style: MoonTypography.typography.heading.text24,
              ),
              const SizedBox(height: 8.0),
              Text(
                'auth.sign_in.subtitle'.tr(),
                style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 32.0),
              MoonOutlinedButton(
                isFullWidth: true,
                borderColor: context.moonColors?.beerus,
                leading: SvgPicture.asset(
                  'assets/images/logo_google.svg',
                  height: 24,
                  width: 24,
                ),
                label: Text('auth.google'.tr()),
                onTap: () {
                  context.read<AuthenticationBloc>().add(const AuthenticationEvent.signInWithGoogle());
                },
              ),
              const SizedBox(height: 16.0),
              MoonOutlinedButton(
                borderColor: context.moonColors?.beerus,
                leading: Icon(_cMagicLink ? MoonIcons.security_password_24_light : MoonIcons.other_lightning_24_light),
                isFullWidth: true,
                label: Text(_cMagicLink ? 'Continue with Password' : 'auth.magic_link'.tr()),
                onTap: () {
                  setState(() {
                    _cMagicLink = !_cMagicLink;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextDivider(text: 'auth.or'.tr()),
              const SizedBox(height: 16.0),
              Text(
                'auth.email'.tr(),
                style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
              ),
              const SizedBox(height: 8.0),
              MoonFormTextInput(
                controller: _emailController,
                textInputSize: MoonTextInputSize.md,
                hintText: 'auth.email_example'.tr(),
                enabled: state.whenOrNull(loading: () => false),
                textInputAction: _cMagicLink ? TextInputAction.done : TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => FormValidation.email(email),
                onSubmitted: (_) => _cMagicLink ? _submitForm() : null,
              ),
              if (!_cMagicLink)
                Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'auth.password'.tr(),
                          style: MoonTypography.typography.heading.text14.copyWith(
                            color: context.moonColors?.trunks,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => context.pushNamed(AppPages.RECOVERY.name),
                            child: Text(
                              'auth.sign_in.forgot_password'.tr(),
                              style:
                                  MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    MoonFormTextInput(
                      controller: _passwordController,
                      textInputSize: MoonTextInputSize.md,
                      obscureText: _obscurePassword,
                      trailing: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? MoonIcons.controls_eye_16_light
                                : MoonIcons.controls_eye_crossed_16_light,
                            color: context.moonColors?.iconSecondary,
                          ),
                        ),
                      ),
                      hintText: 'auth.password_example'.tr(),
                      obscuringCharacter: '●',
                      maxLength: 128,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enabled: state.whenOrNull(loading: () => false),
                      validator: (password) => FormValidation.password(password),
                      onSubmitted: (_) => _submitForm(),
                    ),
                  ],
                ),
              const SizedBox(height: 32.0),
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
                      Text('auth.sign_in.sign_in'.tr())
                    ],
                  ),
                  orElse: () => Text('auth.sign_in.sign_in'.tr()),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.sign_in.dont_have_an_account'.tr(),
                    style: MoonTypography.typography.body.text14.copyWith(
                      color: context.moonColors?.trunks,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.goNamed(AppPages.SIGN_UP.name),
                      child: Text(
                        'auth.sign_in.sign_up'.tr(),
                        style: MoonTypography.typography.heading.text14.copyWith(
                          decoration: TextDecoration.underline,
                        ),
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

// SignUp Page
class _SignUpPage extends StatefulWidget {
  const _SignUpPage();

  @override
  State<_SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<_SignUpPage> {
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
      bloc: GetIt.I.get<AuthenticationBloc>(),
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'auth.sign_up.title'.tr(),
                style: MoonTypography.typography.heading.text24,
              ),
              const SizedBox(height: 8.0),
              Text(
                'auth.sign_up.subtitle'.tr(),
                style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 32.0),
              MoonButton(
                showBorder: true,
                backgroundColor: context.moonColors?.gohan,
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
                label: Text('auth.google'.tr()),
              ),
              const SizedBox(height: 16.0),
              TextDivider(text: 'auth.or'.tr()),
              const SizedBox(height: 16.0),
              Text(
                'auth.email'.tr(),
                style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
              ),
              const SizedBox(height: 8.0),
              MoonFormTextInput(
                onTap: () {},
                controller: _emailController,
                textInputSize: MoonTextInputSize.md,
                hintText: 'auth.email_example'.tr(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: state.whenOrNull(loading: () => false),
                validator: (email) => FormValidation.email(email),
              ),
              const SizedBox(height: 16.0),
              Text(
                'auth.password'.tr(),
                style: MoonTypography.typography.heading.text14.copyWith(
                  color: context.moonColors?.trunks,
                ),
              ),
              const SizedBox(height: 8.0),
              MoonFormTextInput(
                controller: _passwordController,
                textInputSize: MoonTextInputSize.md,
                obscureText: true,
                hintText: 'auth.password_example'.tr(),
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
                      Text('auth.sign_up.sign_up'.tr())
                    ],
                  ),
                  orElse: () => Text('auth.sign_up.sign_up'.tr()),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.sign_up.have_an_account'.tr(),
                    style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                  ),
                  const SizedBox(width: 8.0),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.goNamed(AppPages.SIGN_IN.name),
                      child: Text(
                        'auth.sign_up.sign_in'.tr(),
                        style: MoonTypography.typography.heading.text14.copyWith(
                          decoration: TextDecoration.underline,
                        ),
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

enum AuthPageRoutes { SIGNIN, SIGNUP }
