import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
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
            constraints: const BoxConstraints(maxWidth: 260),
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Database'),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    children: [
/*                       List.generate(
                        8,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: MoonMenuItem(
                              onTap: () {},
                              backgroundColor: index == 0 ? context.moonColors?.heles : null,
                              label: Text('Table #$index')),
                        ),
                      ), */
                      MoonButton(
                        onTap: () {
                          context.read<AuthenticationBloc>().add(AuthenticationEvent.signOut());
                        },
                        isFullWidth: true,
                        leading: Text('Table #032'),
                      ),
                      SizedBox(height: 8.0),
                      MoonButton(
                        onTap: () {},
                        backgroundColor: context.moonColors?.heles,
                        isFullWidth: true,
                        leading: Text('Table #032'),
                      ),
                      SizedBox(height: 8.0),
                      MoonButton(
                        onTap: () {},
                        isFullWidth: true,
                        leading: Text('Table #032'),
                      ),
                      SizedBox(height: 8.0),
                      MoonButton(
                        onTap: () {},
                        isFullWidth: true,
                        leading: Text('Table #032'),
                      ),
                      SizedBox(height: 8.0),
                      MoonButton(
                        onTap: () {},
                        isFullWidth: true,
                        leading: Text('Table #032'),
                      ),
                    ],
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
                AppBar(
                  automaticallyImplyLeading: false,
                ),
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
                                  selectedTextColor: context.moonColors?.bulma,
                                  indicatorColor: context.moonColors?.bulma,
                                  textColor: context.moonColors?.trunks,
                                ),
                              ),
                              MoonTab(
                                tabStyle: MoonTabStyle(
                                  selectedTextColor: context.moonColors?.bulma,
                                  indicatorColor: context.moonColors?.bulma,
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
