import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/utils/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MoonMenuItem(
                onTap: () {
                  CommonBloc.themeProvider.toggleTheme();
                },
                backgroundColor: context.moonColors?.heles,
                label: const Text('Theme'),
                leading: const MoonIcon(MoonIcons.other_water_24_light),
                trailing: MoonSwitch(
                  activeTrackWidget: const MoonIcon(MoonIcons.other_moon_16_light),
                  inactiveTrackWidget: const MoonIcon(MoonIcons.other_sun_16_light),
                  value: context.read<ThemeProvider>().currentTheme == ThemeMode.dark ? true : false,
                  onChanged: (val) => CommonBloc.themeProvider.toggleTheme(),
                ),
              ),
              const SizedBox(height: 16.0),
              MoonFilledButton(
                isFullWidth: true,
                onTap: () async {
                  context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut());
                },
                label: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
