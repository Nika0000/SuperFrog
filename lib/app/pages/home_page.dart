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
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.moonColors!.beerus),
          ),
        ),
        child: BottomNavigationBar(
          onTap: (val) => setState(() => _selectedIndex = val),
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: MoonIcon(MoonIcons.generic_home_24_light),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: MoonIcon(MoonIcons.chart_dashboard_24_light),
              label: 'Owerview',
            ),
            BottomNavigationBarItem(
              icon: MoonIcon(MoonIcons.mail_box_24_light),
              label: 'Messages',
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: context.moonColors?.goku,
        elevation: 0.0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: Center(
          child: MoonButton.icon(
            onTap: () {},
            icon: const MoonIcon(MoonIcons.generic_burger_regular_24_regular),
          ),
        ),
        title: const Text('Dashboard'),
        actions: [
          MoonButton.icon(
            onTap: () {},
            icon: const MoonIcon(MoonIcons.generic_settings_24_regular),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      backgroundColor: context.moonColors!.goku,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MoonMenuItem(
                onTap: () => CommonBloc.themeProvider.toggleTheme(),
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
