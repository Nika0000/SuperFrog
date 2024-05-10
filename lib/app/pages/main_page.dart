// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:path/path.dart';
import 'package:superfrog/app/pages/home/home_page.dart';
import 'package:superfrog/app/pages/news/news_page.dart';
import 'package:superfrog/app/pages/profile/notifications_page.dart';
import 'package:superfrog/app/pages/profile/settings_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/utils/extensions.dart';
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
  late MainPageRoutes _currentPage;
  String? profileUrl = null;

  @override
  void initState() {
    _currentPage = widget.initialRoute!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthenticationBloc>().state.whenOrNull(
          authenticated: (user) => profileUrl = user?.userMetadata?['avatar_url'],
        );
    return Scaffold(
      /* appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(MoonIcons.generic_burger_regular_24_regular),
        ),
        titleSpacing: 0,
        title: Text(_currentPage.label),
        actions: [
          /*  Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              child: CircleAvatar(
                backgroundImage: profileUrl != null ? NetworkImage(profileUrl!) : null,
                radius: 18,
              ),
            ),
          ), */
        ],
      ), */
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo_small.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      MainPageRoutes.values.length * 2 - 1,
                      (index) {
                        if (index.isEven) {
                          bool isSelected = _currentPage == MainPageRoutes.values[index ~/ 2];
                          return MoonButton.icon(
                            icon: MainPageRoutes.values[index ~/ 2].icon,
                            iconColor: isSelected ? context.moonColors?.textPrimary : context.moonColors?.textSecondary,
                            backgroundColor: isSelected ? context.moonColors?.heles : Colors.transparent,
                            borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
                            onTap: () {
                              setState(() => _currentPage = MainPageRoutes.values[index ~/ 2]);
                            },
                          );
                        } else {
                          return const SizedBox(height: 8.0);
                        }
                      },
                    ),
                  ),
                ),
                const Expanded(child: SizedBox(height: 32.0)),
                MoonButton.icon(
                  icon: const Icon(MoonIcons.generic_settings_24_regular),
                  iconColor: context.moonColors?.textSecondary,
                  //     iconColor: isSelected ? context.moonColors?.textPrimary : context.moonColors?.textSecondary,
                  //    backgroundColor: isSelected ? context.moonColors?.gohan : Colors.transparent,
                  onTap: () {
                    showMoonModal(
                      context: context,
                      builder: (context) {
                        return MoonModal(
                          child: ConstrainedBox(
                            constraints: context.responsiveWhen(
                              const BoxConstraints(
                                maxWidth: 900,
                                maxHeight: 600,
                              ),
                              sm: const BoxConstraints.expand(),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: MoonSquircleBorderRadius(cornerRadius: 8.0),
                                border: Border.all(color: context.moonColors!.beerus),
                              ),
                              child: ClipRRect(
                                borderRadius: MoonSquircleBorderRadius(cornerRadius: 8.0),
                                child: const SettingsPage(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                MoonPopover(
                  show: false,
                  borderColor: context.moonColors!.beerus,
                  backgroundColor: context.moonColors?.gohan,
                  popoverPosition: MoonPopoverPosition.topRight,
                  popoverShadows: const [],
                  borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
                  maxWidth: 200,
                  child: MoonButton.icon(
                    icon: const Icon(MoonIcons.generic_user_24_regular),
                    iconColor: context.moonColors?.textSecondary,
                    //     iconColor: isSelected ? context.moonColors?.textPrimary : context.moonColors?.textSecondary,
                    //    backgroundColor: isSelected ? context.moonColors?.gohan : Colors.transparent,
                    onTap: () {
                      setState(
                        () {},
                      );
                    },
                  ),
                  contentPadding: const EdgeInsets.all(4.0),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nika Inasaridze',
                              style: MoonTypography.typography.body.text14,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'nika@wime.host',
                              style: MoonTypography.typography.body.text12
                                  .copyWith(color: context.moonColors?.textSecondary),
                            ),
                          ],
                        ),
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
                            ? Icon(
                                MoonIcons.software_turn_off_16_light,
                                size: 16.0,
                              )
                            : SizedBox(
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
                            ? Icon(
                                MoonIcons.software_turn_off_16_light,
                                size: 16.0,
                              )
                            : SizedBox(
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
                            ? Icon(
                                MoonIcons.software_turn_off_16_light,
                                size: 16.0,
                              )
                            : SizedBox(
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
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          const VerticalDivider(
            width: 1,
          ),
          Expanded(
            child: Scaffold(
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MoonBreadcrumb(
                        divider: Text(
                          '/',
                          style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                        ),
                        items: [
                          MoonBreadcrumbItem(label: Text('Home'), onTap: () {}),
                          MoonBreadcrumbItem(label: Text('Actions'), onTap: () {}),
                          MoonBreadcrumbItem(label: Text('Delete Books'), onTap: () {}),
                          MoonBreadcrumbItem(label: Text('Confirm'), onTap: () {}),
                        ],
                      ),
                      Row(
                        children: [
                          MoonOutlinedButton(
                            onTap: () {},
                            borderColor: context.moonColors?.beerus,
                            buttonSize: MoonButtonSize.sm,
                            label: Text(
                              'Feedback',
                              style: MoonTypography.typography.body.text12.copyWith(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          MoonButton.icon(
                            onTap: () {},
                            showBorder: true,
                            borderColor: context.moonColors?.beerus,
                            buttonSize: MoonButtonSize.sm,
                            icon: Icon(
                              MoonIcons.mail_box_16_light,
                              color: context.moonColors?.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          MoonButton.icon(
                            onTap: () {},
                            showBorder: true,
                            borderColor: context.moonColors?.beerus,
                            buttonSize: MoonButtonSize.sm,
                            icon: Icon(
                              MoonIcons.generic_help_16_light,
                              color: context.moonColors?.textSecondary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                body: _currentPage.page,),
          ),
        ],
      ),
      /*  bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.moonColors?.goku,
          border: Border(
            top: BorderSide(color: context.moonColors!.beerus),
          ),
          //boxShadow: context.moonShadows?.sm,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
          child: BottomNavigationBar(
            currentIndex: _currentPage.index,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: (page) => setState(() => _currentPage = MainPageRoutes.values[page]),
            backgroundColor: context.moonColors?.goku,
            items: List.generate(
              MainPageRoutes.values.length,
              (index) => BottomNavigationBarItem(
                icon: MainPageRoutes.values[index].icon,
                label: MainPageRoutes.values[index].label,
              ),
            ),
          ),
        ),
      ), */
    );
  }
}

enum MainPageRoutes {
  HOME(Icon(MoonIcons.generic_home_24_light), "Home", HomePage()),
  NEWS(Icon(MoonIcons.generic_news_24_light), "News", NewsPage()),
  NEWPOST(Icon(MoonIcons.controls_plus_24_light), "Create", NewsPage()),
  CHAT(Icon(MoonIcons.chat_chat_24_light), "Chat", HomePage()),
  INBOX(Icon(MoonIcons.notifications_bell_24_light), "Inbox", NotificationsPage());

  final Icon icon;
  final String label;
  final Widget page;
  const MainPageRoutes(this.icon, this.label, this.page);
}
