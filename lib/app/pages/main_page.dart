// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/home_page.dart';
import 'package:superfrog/app/pages/news/news_page.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';

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

  @override
  void initState() {
    _currentPage = widget.initialRoute!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage.page,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.moonColors!.trunks),
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
  PROFILE(Icon(MoonIcons.generic_news_24_regular), "News", HomePage()),
  NEWPOST(Icon(MoonIcons.controls_plus_24_regular), "create", NewsPage()),
  NEWS(Icon(MoonIcons.chat_chat_24_regular), "Chat", HomePage()),
  SETTINGS(Icon(MoonIcons.notifications_bell_24_regular), "Inbox", HomePage());

  final Icon icon;
  final String label;
  final Widget page;
  const MainPageRoutes(this.icon, this.label, this.page);
}
