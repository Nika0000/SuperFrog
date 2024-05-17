import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/form_validation.dart';

class AuthCallBackPage extends StatefulWidget {
  final String? token;
  final String? type;

  const AuthCallBackPage({super.key, this.token, this.type});

  @override
  State<AuthCallBackPage> createState() => _AuthCallBackPageState();
}

class _AuthCallBackPageState extends State<AuthCallBackPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: GetIt.I.get<AuthenticationBloc>(),
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
        child: switch (widget.type) {
          'recovery' => _UpdatePassword(token: widget.token),
          'magiclink' => _MagicLink(token: widget.token),
          _ => const ErrorPage(title: 'Page not found'),
        },
      ),
    );
  }
}

/// Magiclink

class _MagicLink extends StatefulWidget {
  final String? token;
  const _MagicLink({this.token});

  @override
  State<_MagicLink> createState() => _MagicLinkState();
}

class _MagicLinkState extends State<_MagicLink> {
  @override
  void initState() {
    context.read<AuthenticationBloc>().add(AuthenticationEvent.signInWithMagicLink(token: widget.token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: GetIt.I.get<AuthenticationBloc>(),
      builder: (context, state) {
        return Center(
          child: state.maybeWhen(
            error: (error) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state.maybeWhen(
                  orElse: () => SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: context.moonColors?.dodoria10),
                      child: Icon(
                        MoonIcons.generic_close_32_light,
                        color: context.moonColors?.dodoria,
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Verifing Failed",
                  style: MoonTypography.typography.body.text16,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "Please do not refresh or closing this page while\nwe authenticate your session.",
                  textAlign: TextAlign.center,
                  style: MoonTypography.typography.body.text12.copyWith(
                    color: context.moonColors?.textSecondary,
                  ),
                ),
              ],
            ),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: MoonCircularLoader(
                    circularLoaderSize: MoonCircularLoaderSize.sm,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Verifing session",
                  style: MoonTypography.typography.body.text16,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "Please do not refresh or closing this page while\nwe authenticate your session.",
                  textAlign: TextAlign.center,
                  style: MoonTypography.typography.body.text12.copyWith(
                    color: context.moonColors?.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Update Password

class _UpdatePassword extends StatefulWidget {
  final String? token;

  const _UpdatePassword({this.token});

  @override
  State<_UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<_UpdatePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: GetIt.I.get<AuthenticationBloc>(),
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Align(
            alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: MediaQuery.of(context).size.width)),
              child: Container(
                padding: const EdgeInsets.all(16.0),
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
                      style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
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
                      style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
                    ),
                    const SizedBox(height: 8.0),
                    MoonFormTextInput(
                      textInputSize: MoonTextInputSize.md,
                      hintText: 'password',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (cPassword) => cPassword != _passwordController.text ? "Password is not same" : null,
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
                          style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                        ),
                        const SizedBox(width: 8.0),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => context.replaceNamed(AppPages.SIGN_IN.name),
                            child: Text(
                              'Sign In Now',
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
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
