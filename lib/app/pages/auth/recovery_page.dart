import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/widgets/home_button.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/routes/app_routes.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/form_validation.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
            AuthenticationEvent.resetPassword(
              email: _emailController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: GetIt.I.get<AuthenticationBloc>(),
      builder: (context, state) {
        return Scaffold(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auth.recovery_password.title'.tr(),
                        style: MoonTypography.typography.heading.text24,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'auth.recovery_password.subtitle'.tr(),
                        style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.textSecondary),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'auth.email'.tr(),
                        style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
                      ),
                      const SizedBox(height: 8.0),
                      MoonFormTextInput(
                        controller: _emailController,
                        textInputAction: TextInputAction.done,
                        hintText: 'auth.email_example'.tr(),
                        enabled: state.whenOrNull(loading: () => false),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) => FormValidation.email(email),
                        onSubmitted: (_) => _submitForm(),
                      ),
                      const SizedBox(height: 24.0),
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
                              Text('auth.recovery_password.send_reset_email'.tr())
                            ],
                          ),
                          orElse: () => Text('auth.recovery_password.send_reset_email'.tr()),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'auth.recovery_password.already_have_an_acc'.tr(),
                            style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                          ),
                          const SizedBox(width: 8.0),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => context.goNamed(AppPages.SIGN_IN.name),
                              child: Text(
                                'auth.recovery_password.sign_in'.tr(),
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
    super.dispose();
    _emailController.dispose();
  }
}
