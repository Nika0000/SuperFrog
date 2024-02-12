// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/home_page.dart';
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
  bool showOnTap = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Center(
                      child: SvgPicture.network(
                        'https://supabase.com/dashboard/img/supabase-logo.svg',
                        height: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  MoonButton.icon(
                    onTap: () => setState(() => showOnTap = true),
                    iconColor: context.moonColors?.trunks,
                    backgroundColor: context.moonColors?.heles,
                    buttonSize: MoonButtonSize.md,
                    hoverTextColor: context.moonColors?.bulma,
                    icon: const MoonIcon(MoonIcons.generic_home_24_regular),
                  ),
                  const SizedBox(height: 8.0),
                  MoonButton.icon(
                    onTap: () {},
                    hoverTextColor: context.moonColors?.bulma,
                    iconColor: context.moonColors?.trunks,
                    icon: const MoonIcon(MoonIcons.sport_table_tennis_24_regular),
                  ),
                  const SizedBox(
                    width: 40,
                    height: 24,
                    child: Divider(),
                  ),
                  MoonButton.icon(
                    onTap: () {},
                    hoverTextColor: context.moonColors?.bulma,
                    iconColor: context.moonColors?.trunks,
                    icon: const MoonIcon(MoonIcons.sport_american_football_24_regular),
                  ),
                  const SizedBox(height: 8.0),
                  MoonButton.icon(
                    onTap: () {},
                    hoverTextColor: context.moonColors?.bulma,
                    iconColor: context.moonColors?.trunks,
                    icon: const MoonIcon(MoonIcons.generic_alarm_24_regular),
                  ),
                  const SizedBox(height: 8.0),
                  MoonButton.icon(
                    onTap: () {},
                    hoverTextColor: context.moonColors?.bulma,
                    iconColor: context.moonColors?.trunks,
                    icon: const MoonIcon(MoonIcons.generic_block_24_regular),
                  ),
                  const SizedBox(
                    width: 40,
                    height: 24,
                    child: Divider(),
                  ),
                  MoonButton.icon(
                    iconColor: context.moonColors?.trunks,
                    hoverTextColor: context.moonColors?.bulma,
                    onTap: () => context.read<ThemeProvider>().toggleTheme(),
                    icon: const MoonIcon(MoonIcons.generic_betslip_24_regular),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 1,
            ),
            Expanded(
              child: HomePage(),
            ),
          ],
        ),
      ),
    );
  }
}

enum MainPageRoutes {
  HOME,
}
