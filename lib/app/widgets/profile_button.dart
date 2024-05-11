import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/utils/theme_provider.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return MoonPopover(
      show: isOpened,
      borderColor: context.moonColors!.beerus,
      backgroundColor: context.moonColors?.gohan,
      popoverPosition: MoonPopoverPosition.topRight,
      popoverShadows: const [],
      borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
      maxWidth: 200,
      onTapOutside: () => setState(() {
        isOpened = false;
      }),
      contentPadding: const EdgeInsets.all(4.0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.read<AuthenticationBloc>().state.maybeWhen(
                authenticated: (user) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: MoonTypography.typography.body.text14,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        user?.email ?? 'undefined',
                        style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.textSecondary),
                      ),
                    ],
                  ),
                ),
                orElse: () => Container(),
              ),
          const Divider(height: 8.0),
          MoonMenuItem(
            label: Text(
              'Account preferences',
              style: MoonTypography.typography.body.text12.copyWith(
                color: context.moonColors?.textSecondary,
              ),
            ),
            borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
            height: 38,
            onTap: () {},
          ),
          const Divider(height: 8.0),
          MoonMenuItem(
            leading: context.read<ThemeProvider>().currentTheme == ThemeMode.system
                ? const Icon(
                    MoonIcons.software_turn_off_16_light,
                    size: 16.0,
                  )
                : const SizedBox(
                    height: 16.0,
                    width: 16.0,
                  ),
            label: Text(
              'System',
              style: MoonTypography.typography.body.text12.copyWith(
                color: context.moonColors?.textSecondary,
              ),
            ),
            borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
            height: 38,
            onTap: () {
              context.read<ThemeProvider>().toggleTheme(mode: ThemeMode.system);
            },
          ),
          MoonMenuItem(
            leading: context.read<ThemeProvider>().currentTheme == ThemeMode.light
                ? const Icon(
                    MoonIcons.software_turn_off_16_light,
                    size: 16.0,
                  )
                : const SizedBox(
                    height: 16.0,
                    width: 16.0,
                  ),
            label: Text(
              'Light',
              style: MoonTypography.typography.body.text12.copyWith(
                color: context.moonColors?.textSecondary,
              ),
            ),
            borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
            height: 38,
            onTap: () {
              context.read<ThemeProvider>().toggleTheme(mode: ThemeMode.light);
            },
          ),
          MoonMenuItem(
            leading: context.read<ThemeProvider>().currentTheme == ThemeMode.dark
                ? const Icon(
                    MoonIcons.software_turn_off_16_light,
                    size: 16.0,
                  )
                : const SizedBox(
                    height: 16.0,
                    width: 16.0,
                  ),
            label: Text(
              'Dark',
              style: MoonTypography.typography.body.text12.copyWith(
                color: context.moonColors?.textSecondary,
              ),
            ),
            borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
            height: 38,
            onTap: () {
              context.read<ThemeProvider>().toggleTheme(mode: ThemeMode.dark);
            },
          ),
          const Divider(height: 8.0),
          MoonMenuItem(
            label: Text(
              'Log out',
              style: MoonTypography.typography.body.text12.copyWith(
                color: context.moonColors?.textSecondary,
              ),
            ),
            borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
            height: 38,
            onTap: () {
              context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut());
            },
          ),
        ],
      ),
      child: MoonButton.icon(
        icon: const Icon(MoonIcons.generic_user_24_regular),
        iconColor: context.moonColors?.textSecondary,
        backgroundColor: isOpened ? context.moonColors?.gohan : Colors.transparent,
        onTap: () => setState(() {
          isOpened = true;
        }),
      ),
    );
  }
}
