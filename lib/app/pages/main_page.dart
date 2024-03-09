// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/home_page.dart';
import 'package:superfrog/config/preference_config.dart';
import 'package:superfrog/utils/theme_provider.dart';

class MainPage extends StatefulWidget {
  final MainPageRoutes route;
  final MainPageRoutes? initialRoute;
  const MainPage(
    this.route, {
    this.initialRoute = MainPageRoutes.HOME,
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationBarDesktop(),
          VerticalDivider(width: 1),
          Expanded(child: HomePage()),
        ],
      ),
    );
  }
}

enum MainPageRoutes {
  HOME,
}

class NavigationBarDesktop extends StatefulWidget {
  const NavigationBarDesktop({super.key});

  @override
  State<NavigationBarDesktop> createState() => _NavigationBarDesktopState();
}

class _NavigationBarDesktopState extends State<NavigationBarDesktop> {
  int _selectedIndex = 0;
  bool showProfilePop = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: SvgPicture.asset(
            'assets/images/logo_small.svg',
            height: 24,
          ),
        ),
        const SizedBox(child: Divider(height: 1)),
        Expanded(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                  _navigationItems().length * 2,
                  (index) {
                    if (index.isEven) {
                      return _navigationItems()[index ~/ 2];
                    } else {
                      return const SizedBox(height: 12.0);
                    }
                  },
                ),
              ),
            );
          }),
        ),
        MoonButton.icon(
          onTap: () {},
          icon: const MoonIcon(MoonIcons.generic_settings_24_regular),
          iconColor: context.moonColors?.trunks,
          hoverTextColor: context.moonColors?.textPrimary,
        ),
        const SizedBox(height: 12.0),
        MoonPopover(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          backgroundColor: context.moonColors?.gohan,
          popoverPosition: MoonPopoverPosition.topRight,
          borderRadius: context.moonBorders?.interactiveSm,
          show: showProfilePop,
          onTapOutside: () => setState(() => showProfilePop = false),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nika0000', style: MoonTypography.typography.body.text14),
                      const SizedBox(height: 4.0),
                      Text(
                        'nikainasaridze@icloud.com',
                        style: MoonTypography.typography.body.text12.copyWith(
                          color: context.moonColors?.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 12.0),
                MoonMenuItem(
                  onTap: () {},
                  height: 32,
                  borderRadius: context.moonBorders?.interactiveXs,
                  menuItemPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  leading: MoonIcon(
                    MoonIcons.generic_settings_16_light,
                    color: context.moonColors?.textSecondary,
                    size: 16.0,
                  ),
                  label: Text(
                    'Account preferences',
                    style: MoonTypography.typography.body.text12.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                ),
                MoonMenuItem(
                  onTap: () {},
                  height: 32,
                  borderRadius: context.moonBorders?.interactiveXs,
                  menuItemPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  leading: MoonIcon(
                    MoonIcons.other_lightning_16_light,
                    color: context.moonColors?.textSecondary,
                    size: 16.0,
                  ),
                  label: Text(
                    'Feature previews',
                    style: MoonTypography.typography.body.text12.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                ),
                const Divider(height: 12.0),
                MoonMenuItem(
                  onTap: () {},
                  height: 32,
                  borderRadius: context.moonBorders?.interactiveXs,
                  menuItemPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  leading: MoonIcon(
                    MoonIcons.other_water_16_light,
                    color: context.moonColors?.textSecondary,
                    size: 16.0,
                  ),
                  label: Text(
                    'Theme',
                    style: MoonTypography.typography.body.text12.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                  trailing: MoonSwitch(
                    inactiveTrackWidget: const MoonIcon(MoonIcons.other_sun_16_light),
                    activeTrackWidget: const MoonIcon(MoonIcons.other_moon_16_light),
                    switchSize: MoonSwitchSize.x2s,
                    onChanged: (value) {
                      setState(() {
                        context.read<ThemeProvider>().toggleTheme();
                      });
                    },
                    value: Preferences.currentTheme.index == ThemeMode.dark.index ? true : false,
                  ),
                ),
                const Divider(height: 12.0),
                MoonMenuItem(
                  onTap: () {},
                  height: 32,
                  borderRadius: context.moonBorders?.interactiveXs,
                  menuItemPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  leading: MoonIcon(
                    MoonIcons.generic_log_out_16_light,
                    color: context.moonColors?.textSecondary,
                    size: 16.0,
                  ),
                  label: Text(
                    'Log out',
                    style: MoonTypography.typography.body.text12.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: MoonButton.icon(
            backgroundColor: showProfilePop ? context.moonColors?.heles : null,
            iconColor: context.moonColors?.trunks,
            hoverTextColor: context.moonColors?.textPrimary,
            onTap: () => setState(() => showProfilePop = true),
            icon: const MoonIcon(MoonIcons.generic_user_24_regular),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  List<Widget> _navigationItems() {
    return [
      MoonButton.icon(
        onTap: () {},
        icon: const MoonIcon(MoonIcons.files_add_text_24_light),
        backgroundColor: context.moonColors?.heles,
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
      MoonButton.icon(
        onTap: () {},
        icon: const MoonIcon(MoonIcons.files_add_text_24_light),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
      MoonButton.icon(
        onTap: () {},
        icon: const MoonIcon(MoonIcons.files_add_text_24_light),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
      MoonButton.icon(
        onTap: () {},
        icon: const MoonIcon(MoonIcons.files_add_text_24_light),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
      MoonButton.icon(
        onTap: () {},
        icon: const MoonIcon(MoonIcons.files_add_text_24_light),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
      MoonButton.icon(
        onTap: () {},
        icon: const MoonIcon(MoonIcons.files_add_text_24_light),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
    ];
  }
}
