import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/routes/app_routes.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reset Your Password',
          style: MoonTypography.typography.heading.text24,
        ),
        const SizedBox(height: 4.0),
        Text(
          'Type in your email and we`ll send you a link to reset your password',
          style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
        ),
        const SizedBox(height: 32.0),
        Text(
          'Email',
          style: MoonTypography.typography.heading.text14.copyWith(color: context.moonColors?.trunks),
        ),
        const SizedBox(height: 8.0),
        MoonTextInput(
          controller: _emailController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          hintText: 'you@example.com',
        ),
        const SizedBox(height: 24.0),
        MoonFilledButton(
          isFullWidth: true,
          onTap: () {},
          label: const Text('Send Reset Email'),
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: MoonTypography.typography.body.text14,
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () => context.replaceNamed(AppRoutes.SIGNIN),
              child: Text(
                'Sign In',
                style: MoonTypography.typography.heading.text14.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }
}
