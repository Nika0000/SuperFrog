// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/home_page.dart';

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
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: context.moonColors!.beerus,
                ),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: Image.network(
                      'https://supabase.com/dashboard/img/supabase-logo.svg',
                      height: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                MoonButton.icon(
                  onTap: () {},
                  icon: const MoonIcon(MoonIcons.generic_home_32_regular),
                ),
                MoonButton.icon(
                  onTap: () {},
                  icon: const MoonIcon(MoonIcons.sport_table_tennis_32_regular),
                ),
                const SizedBox(
                  width: 40,
                  height: 24,
                  child: Divider(),
                ),
                MoonButton.icon(
                  onTap: () {},
                  icon: const MoonIcon(MoonIcons.sport_american_football_32_regular),
                ),
                MoonButton.icon(
                  onTap: () {},
                  icon: const MoonIcon(MoonIcons.generic_alarm_32_regular),
                ),
                MoonButton.icon(
                  onTap: () {},
                  icon: const MoonIcon(MoonIcons.generic_block_32_regular),
                ),
                const SizedBox(
                  width: 40,
                  height: 24,
                  child: Divider(),
                ),
                MoonButton.icon(
                  onTap: () {},
                  icon: const MoonIcon(MoonIcons.generic_betslip_32_regular),
                ),
              ],
            ),
          ),
          Expanded(
            child: HomePage(),
          ),
        ],
      ),
    );
  }
}

enum MainPageRoutes {
  HOME,
}
