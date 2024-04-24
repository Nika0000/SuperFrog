// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/home/home_page.dart';
import 'package:superfrog/app/pages/news/news_page.dart';
import 'package:superfrog/app/pages/profile/notifications_page.dart';
import 'package:superfrog/app/pages/profile/settings_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(MoonIcons.generic_burger_regular_24_regular),
        ),
        titleSpacing: 0,
        title: Text(_currentPage.label),
        actions: [
          Padding(
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
          ),
        ],
      ),
      body: _currentPage.page,
      bottomNavigationBar: Container(
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
      ),
    );
  }
}

enum MainPageRoutes {
  HOME(Icon(MoonIcons.generic_home_24_regular), "Home", HomePage()),
  NEWS(Icon(MoonIcons.generic_news_24_regular), "News", NewsPage()),
  NEWPOST(Icon(MoonIcons.controls_plus_24_regular), "Create", NewsPage()),
  CHAT(Icon(MoonIcons.chat_chat_24_regular), "Chat", HomePage()),
  INBOX(Icon(MoonIcons.notifications_bell_24_regular), "Inbox", NotificationsPage());

  final Icon icon;
  final String label;
  final Widget page;
  const MainPageRoutes(this.icon, this.label, this.page);
}
