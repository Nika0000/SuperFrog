// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
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
    return const Scaffold(
      body: HomePage(),
    );
  }
}

enum MainPageRoutes {
  HOME,
}
