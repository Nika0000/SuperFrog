import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/app/pages/error_page.dart';
import 'package:superfrog/app/widgets/home_button.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/form_validation.dart';
import 'package:superfrog/utils/platform.dart';

class AuthCallBackPage extends StatefulWidget {
  final String? token;
  final String? type;
  final Map<String, dynamic>? metadata;

  const AuthCallBackPage({super.key, this.token, this.type, this.metadata});

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const HomeButton(),
        actions: [
          if (PlatformUtils.isMobile && context.canPop())
            MoonButton.icon(
              buttonSize: MoonButtonSize.sm,
              icon: const Icon(MoonIcons.controls_close_small_24_light),
              onTap: () => context.pop(),
            ),
          const SizedBox(width: 16.0)
        ],
      ),
      body: switch (widget.type) {
        'recovery' => _UpdatePassword(token: widget.token),
        'magiclink' => _MagicLink(token: widget.token),
        _ => widget.metadata != null
            ? _VerifyToken(
                token: widget.token,
                email: widget.metadata?['email'],
                tokenType: widget.metadata?['type'] ?? OtpType.recovery,
              )
            : const ErrorPage(),
      },
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
                  'Verifing Failed',
                  style: MoonTypography.typography.body.text16,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Please do not refresh or closing this page while\nwe authenticate your session.',
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
                  'Verifing session',
                  style: MoonTypography.typography.body.text16,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Please do not refresh or closing this page while\nwe authenticate your session.',
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
    void submitForm() {
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
        return SafeArea(
          child: Form(
            key: _formKey,
            child: Align(
              alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: context.responsiveWhen(480, sm: MediaQuery.of(context).size.width)),
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
                        'Change Password',
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
                        validator: (cPassword) => cPassword != _passwordController.text ? 'Password is not same' : null,
                        onSubmitted: (_) => submitForm(),
                      ),
                      const SizedBox(height: 48.0),
                      MoonFilledButton(
                        isFullWidth: true,
                        onTap: state.maybeWhen(
                          loading: () => null,
                          orElse: () => submitForm,
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

// Verify token manualy

class _VerifyToken extends StatefulWidget {
  final String? token;
  final String? email;
  final OtpType tokenType;

  const _VerifyToken({this.token, this.email, required this.tokenType});

  @override
  State<_VerifyToken> createState() => __VerifyTokenState();
}

class __VerifyTokenState extends State<_VerifyToken> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!widget.token.isNullOrEmpty) {
      _otpController.text = widget.token.toString();
    }
  }

  void submitForm() {
    context.read<AuthenticationBloc>().add(
          AuthenticationEvent.verifyOTP(
            email: widget.email,
            token: _otpController.text,
            type: widget.tokenType,
            onVerified: () {
              switch (widget.tokenType) {
                case OtpType.recovery:
                  context.pushReplacementNamed(AppPages.AUTH_CALLBACK.name, queryParameters: {'type': 'recovery'});
                default:
                  AppRouter.router.refresh();
                  break;
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: GetIt.I.get<AuthenticationBloc>(),
      listener: (context, state) {
        state.whenOrNull(error: (_) => _otpController.clear());
      },
      child: SafeArea(
        child: Align(
          alignment: context.responsiveWhen(Alignment.center, sm: Alignment.topCenter),
          child: SingleChildScrollView(
            reverse: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.responsiveWhen(480, sm: double.maxFinite)),
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
                      'Verification Code',
                      style: MoonTypography.typography.heading.text24,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'We sent you a code to verify you phone number.\nPlease check your messages and enter the code below.',
                      style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.textSecondary),
                    ),
                    const SizedBox(height: 32.0),
                    LayoutBuilder(
                      builder: (context, constraints) => MoonAuthCode(
                        textController: _otpController,
                        autoFocus: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.go,
                        errorAnimationType: ErrorAnimationType.shake,
                        gap: 12.0,
                        height: constraints.maxWidth / 6.2,
                        width: (constraints.maxWidth - 60) / 6,
                        validator: (String? pin) {
                          if (pin.isNullOrEmpty) return null;

                          // Matches all numbers.
                          final RegExp regex = RegExp(r'^[0-9]+$');

                          return pin != null && !regex.hasMatch(pin) ? 'The input must only contain numbers' : null;
                        },
                        errorBuilder: (BuildContext context, String? errorText) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(errorText ?? ''),
                            ),
                          );
                        },
                        onCompleted: (_) => submitForm(),
                        onSubmitted: (_) => submitForm(),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Don`t get a code?',
                          style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                        ),
                        const SizedBox(width: 8.0),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Resend',
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
