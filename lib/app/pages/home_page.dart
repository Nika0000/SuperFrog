import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/utils/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Column(
              children: [
                AppBar(
                  title: const Text('Database'),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    children: List.generate(
                      8,
                      (index) => MoonMenuItem(
                        onTap: () {},
                        label: index == 0
                            ? Text('Table #$index')
                            : Text(
                                'Table #$index',
                                style: MoonTypography.typography.heading.text14.copyWith(
                                  color: context.moonColors?.trunks,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(),
                SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: context.responsiveWhen(64, sm: 24), vertical: 24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1440),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Database Tables",
                            style: MoonTypography.typography.heading.text20,
                          ),
                          const SizedBox(height: 24.0),
                          MoonTabBar(
                            tabs: [
                              MoonTab(
                                label: Text('Scheduled backups'),
                                tabStyle: MoonTabStyle(
                                  selectedTextColor: context.moonColors?.goten,
                                  indicatorColor: context.moonColors?.goten,
                                  textColor: context.moonColors?.trunks,
                                ),
                              ),
                              MoonTab(
                                tabStyle: MoonTabStyle(
                                  selectedTextColor: context.moonColors?.goten,
                                  indicatorColor: context.moonColors?.goten,
                                  textColor: context.moonColors?.trunks,
                                ),
                                label: Text('Scheduled backups'),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Projects are backed up daily around midnight of your project`s region and can be restored at any time.',
                            style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                          ),
                          const SizedBox(height: 24.0),
                          MoonAlert.filled(
                            leading: MoonIcon(MoonIcons.time_clock_32_light),
                            backgroundColor: context.moonColors!.gohan,
                            label: Text(
                              'Free Plan does not include project backups.',
                            ),
                            trailing: MoonFilledButton(
                              onTap: () {},
                              buttonSize: MoonButtonSize.sm,
                              label: Text('Upgrade Pro'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
