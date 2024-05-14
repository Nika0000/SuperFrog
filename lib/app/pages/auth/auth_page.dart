// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/auth/recovery_page.dart';
import 'package:superfrog/app/pages/auth/signin_page.dart';
import 'package:superfrog/app/pages/auth/signup_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/form_validation.dart';

class AuthPage extends StatefulWidget {
  final AuthPageRoutes route;
  const AuthPage(this.route, {super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: CommonBloc.authenticationBloc,
      listener: (context, state) {
        state.whenOrNull(
          error: (error) {
            return MoonToast.show(
              context,
              toastShadows: context.moonShadows?.sm,
              label: Text(error),
              leading: const Icon(MoonIcons.generic_alarm_24_light),
            );
          },
          message: (message) {
            return MoonToast.show(
              context,
              toastShadows: context.moonShadows?.sm,
              leading: const Icon(MoonIcons.generic_check_rounded_24_light),
              label: Text(message),
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
          title: Theme.of(context).brightness == Brightness.light
              ? SvgPicture.asset(
                  'assets/images/logo_dark.svg',
                  height: 24.0,
                )
              : SvgPicture.asset(
                  'assets/images/logo_light.svg',
                  height: 24.0,
                ),
        ),
        body: Align(
          alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.maxFinite)),
              child: switch (widget.route) {
                AuthPageRoutes.SIGNIN => const SignInPage(),
                AuthPageRoutes.SIGNUP => const SignUpPage(),
                AuthPageRoutes.RECOVERY => const RecoveryPage(),
                AuthPageRoutes.UPDATE_PASSWORD => const OAuthCallBack(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum AuthPageRoutes { SIGNIN, SIGNUP, RECOVERY, UPDATE_PASSWORD }

class OAuthCallBack extends StatefulWidget {
  final String? token;
  final String? type;
  const OAuthCallBack({this.token, this.type, super.key});

  @override
  State<OAuthCallBack> createState() => _OAuthCallBackState();
}

class _OAuthCallBackState extends State<OAuthCallBack> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
            AuthenticationEvent.updatePassword(
              token: widget.token,
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.moonColors?.goku,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        bloc: CommonBloc.authenticationBloc,
        listener: (context, state) {
          state.whenOrNull(
            error: (error) {
              return MoonToast.show(
                context,
                toastShadows: context.moonShadows?.sm,
                label: Text(error),
                leading: const Icon(MoonIcons.generic_alarm_24_light),
              );
            },
            message: (message) {
              return MoonToast.show(
                context,
                toastShadows: context.moonShadows?.sm,
                leading: const Icon(MoonIcons.generic_check_rounded_24_light),
                label: Text(message),
              );
            },
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Align(
                alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.maxFinite)),
                  child: switch (widget.type) {
                    'recovery' => Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: context.responsiveWhen(
                          BoxDecoration(
                            color: context.moonColors?.gohan,
                            borderRadius: MoonSquircleBorderRadius(cornerRadius: 8.0),
                            boxShadow: context.moonShadows?.sm,
                          ),
                          sm: const BoxDecoration(),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Change Password",
                              style: MoonTypography.typography.heading.text24,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'New Password',
                              style:
                                  MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
                            ),
                            const SizedBox(height: 8.0),
                            MoonFormTextInput(
                              controller: _passwordController,
                              textInputSize: MoonTextInputSize.md,
                              hintText: 'password',
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (password) => FormValidation.password(password),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Confirm Password',
                              style:
                                  MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
                            ),
                            const SizedBox(height: 8.0),
                            MoonFormTextInput(
                              textInputSize: MoonTextInputSize.md,
                              hintText: 'password',
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (cPassword) =>
                                  cPassword != _passwordController.text ? "Password is not same" : null,
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
                                    const Text('Update Password'),
                                  ],
                                ),
                                orElse: () => const Text('Update Password'),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Have an account?',
                                  style:
                                      MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                                ),
                                const SizedBox(width: 8.0),
                                GestureDetector(
                                  onTap: () => context.replaceNamed(AppPages.SIGN_IN.name),
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
                      ),
                    _ => const Text('_')
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
