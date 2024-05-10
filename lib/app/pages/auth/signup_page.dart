import 'package:easy_localization/easy_localization.dart';
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
                  GestureDetector(
                    onTap: () => context.goNamed(AppPages.SIGN_IN.name),
                    child: Text(
                      'auth.sign_up.sign_in'.tr(),
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
