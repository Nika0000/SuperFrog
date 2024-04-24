import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        backgroundColor: context.moonColors?.gohan,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                MoonTabBar(
                  gap: 16.0,
                  tabController: _tabController,
                  isExpanded: false,
                  tabs: [
                    MoonTab(
                      label: const Text('Inbox'),
                      tabStyle: MoonTabStyle(
                        tabPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        selectedTextColor: context.moonColors?.textPrimary,
                        textColor: context.moonColors?.textSecondary,
                        indicatorColor: context.moonColors?.textPrimary,
                      ),
                    ),
                    MoonTab(
                      label: const Text('Archived'),
                      tabStyle: MoonTabStyle(
                        tabPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        selectedTextColor: context.moonColors?.textPrimary,
                        textColor: context.moonColors?.textSecondary,
                        indicatorColor: context.moonColors?.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox(width: 32.0)),
                MoonButton.icon(
                  onTap: () {},
                  buttonSize: MoonButtonSize.sm,
                  icon: const Icon(
                    MoonIcons.software_settings_16_light,
                    size: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32.0,
                MoonIcons.mail_box_32_light,
                color: context.moonColors?.textSecondary,
              ),
              const SizedBox(height: 8.0),
              Text(
                'All caught up',
                style: MoonTypography.typography.heading.text16.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 8.0),
              Text(
                'You will be notified here for any notices on\nyour organizations and projects',
                textAlign: TextAlign.center,
                style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
              )
            ],
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32.0,
                MoonIcons.mail_box_32_light,
                color: context.moonColors?.textSecondary,
              ),
              const SizedBox(height: 8.0),
              Text(
                'No archived notifications',
                style: MoonTypography.typography.heading.text16.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Notifications that you have previously\narchived will be shown here',
                textAlign: TextAlign.center,
                style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
