// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/home/home_page.dart';
import 'package:superfrog/app/pages/settings/settings_page.dart';
import 'package:superfrog/app/pages/websocket/socket_page.dart';
import 'package:superfrog/app/pages/profile/notifications_page.dart';
import 'package:superfrog/app/pages/storage/storage_page.dart';
import 'package:superfrog/app/widgets/profile_button.dart';
import 'package:superfrog/utils/extensions.dart';

class MainPage extends StatefulWidget {
  final MainPageRoutes route;
  final MainPageRoutes? initialRoute;
  final bool showAppbar;
  final bool showNavigationBar;
  const MainPage(
    this.route, {
    this.initialRoute = MainPageRoutes.HOME,
    this.showAppbar = true,
    this.showNavigationBar = true,
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainPageRoutes _currentPage;

  @override
  void initState() {
    _currentPage = widget.initialRoute!;
    super.initState();
  }

  AppBar adaptiveAppBar(BuildContext context) => AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            context.responsiveWhen(
              MoonBreadcrumb(
                divider: Text(
                  '/',
                  style: MoonTypography.typography.body.text14.copyWith(color: context.moonColors?.trunks),
                ),
                items: [
                  MoonBreadcrumbItem(label: const Text('Home'), onTap: () {}),
                  MoonBreadcrumbItem(label: const Text('Actions'), onTap: () {}),
                  MoonBreadcrumbItem(label: const Text('Delete Books'), onTap: () {}),
                  MoonBreadcrumbItem(label: const Text('Confirm'), onTap: () {}),
                ],
              ),
              sm: Text(_currentPage.label),
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile && widget.showAppbar ? adaptiveAppBar(context) : null,
      body: context.responsiveWhen(
        Row(
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
                              iconColor:
                                  isSelected ? context.moonColors?.textPrimary : context.moonColors?.textSecondary,
                              backgroundColor: isSelected ? context.moonColors?.heles : Colors.transparent,
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
                    onTap: () {},
                  ),
                  const SizedBox(height: 8.0),
                  const ProfileButton(),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            const VerticalDivider(
              width: 1,
            ),
            Expanded(
              child: Scaffold(
                appBar: adaptiveAppBar(context),
                body: _currentPage.page,
              ),
            ),
          ],
        ),
        sm: _currentPage.page,
      ),
      bottomNavigationBar: context.isMobile
          ? Container(
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
            )
          : null,
    );
  }
}

enum MainPageRoutes {
  HOME(Icon(MoonIcons.generic_home_24_light), "Home", HomePage()),
  STORAGE(Icon(MoonIcons.files_text_24_light), "Storage", StoragePage()),
  SETTINGS(Icon(MoonIcons.software_settings_24_light), "Settings", SettingsPage()),
  WEBSOCKET(Icon(MoonIcons.arrows_transfer_24_light), "Socket", WebSocketPage()),
  INBOX(Icon(MoonIcons.notifications_bell_24_light), "Inbox", NotificationsPage());

  final Icon icon;
  final String label;
  final Widget page;
  const MainPageRoutes(this.icon, this.label, this.page);
}
