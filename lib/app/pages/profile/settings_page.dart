import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/app/pages/profile/notifications_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACCOUNT SETTINGS',
              style: MoonTypography.typography.heading.text10.copyWith(color: context.moonColors?.textSecondary),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {},
              leading: const Icon(MoonIcons.generic_user_24_regular),
              label: const Text('Account'),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {},
              leading: const Icon(MoonIcons.security_key_24_regular),
              label: const Text('Privacy & Safety'),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {},
              leading: const Icon(MoonIcons.devices_macbook_24_regular),
              label: const Text('Devices'),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 16.0),
            Text(
              'DEVICE SETTINGS',
              style: MoonTypography.typography.heading.text10.copyWith(color: context.moonColors?.textSecondary),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(),
                  ),
                );
              },
              leading: const Icon(MoonIcons.notifications_bell_24_regular),
              label: const Text('Notifications'),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguagesPage()));
              },
              leading: const Icon(MoonIcons.generic_globe_24_regular),
              label: Text(context.locale.name),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {
                context.read<ThemeProvider>().toggleTheme();
              },
              leading: const Icon(MoonIcons.other_moon_24_regular),
              label: Text(switch (context.read<ThemeProvider>().currentTheme) {
                ThemeMode.light => 'Light',
                ThemeMode.dark => 'Dark',
                _ => 'System'
              }),
              trailing: MoonSwitch(
                value: context.read<ThemeProvider>().currentTheme == ThemeMode.dark,
                onChanged: (_) {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {},
              leading: const Icon(MoonIcons.software_settings_24_regular),
              label: const Text('Clear cache'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'HELP AND FEEDBACKS',
              style: MoonTypography.typography.heading.text10.copyWith(color: context.moonColors?.textSecondary),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {},
              leading: const Icon(MoonIcons.devices_phone_24_regular),
              label: const Text('Onboarding'),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 8.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {},
              leading: const Icon(MoonIcons.generic_help_24_regular),
              label: const Text('Help Center'),
              trailing: const Icon(MoonIcons.controls_chevron_right_24_regular),
            ),
            const SizedBox(height: 16.0),
            MoonMenuItem(
              backgroundColor: context.moonColors?.gohan,
              onTap: () {
                context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut());
              },
              leading: Icon(
                MoonIcons.generic_log_out_24_regular,
                color: context.moonColors?.dodoria,
              ),
              label: Text(
                'Log Out',
                style: const TextStyle().copyWith(color: context.moonColors?.dodoria),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Language'),
      ),
      body: SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          itemCount: context.supportedLocales.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
          itemBuilder: (context, index) => MoonMenuItem(
            trailing: MoonRadio(
              value: context.supportedLocales[index],
              groupValue: context.locale,
              tapAreaSizeValue: 0,
              onChanged: (_) {},
            ),
            backgroundColor: context.locale == context.supportedLocales[index] ? context.moonColors?.gohan : null,
            onTap: () => context.setLocale(context.supportedLocales[index]),
            label: Text(context.supportedLocales[index].name),
          ),
        ),
      ),
    );
  }
}

class UserSessionsPage extends StatefulWidget {
  const UserSessionsPage({super.key});

  @override
  State<UserSessionsPage> createState() => UserSessionsPageState();
}

class UserSessionsPageState extends State<UserSessionsPage> {
  @override
  void initState() {
    Supabase.instance.client.auth.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
