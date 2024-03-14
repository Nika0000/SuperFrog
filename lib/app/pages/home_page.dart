import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      endDrawer: MoonDrawer(
        child: _createNewGame(),
      ),
      body: PagePanelBuilder(
        bodyPanel: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage',
                style: MoonTypography.typography.heading.text12.copyWith(color: context.moonColors?.textSecondary),
              ),
              const SizedBox(height: 8.0),
              MoonMenuItem(
                onTap: () {},
                height: 32,
                backgroundColor: context.moonColors?.heles,
                borderRadius: context.moonBorders?.interactiveXs,
                menuItemPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                label: Text(
                  'Games',
                  style: MoonTypography.typography.body.text12.copyWith(),
                ),
              ),
              const SizedBox(height: 8.0),
              MoonMenuItem(
                onTap: () {},
                height: 32,
                borderRadius: context.moonBorders?.interactiveXs,
                menuItemPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                label: Text(
                  'Storage',
                  style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
                ),
              ),
              const Divider(height: 16),
              MoonMenuItem(
                onTap: () {},
                height: 32,
                borderRadius: context.moonBorders?.interactiveXs,
                menuItemPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                label: Text(
                  'Templates',
                  style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
                ),
              ),
              const SizedBox(height: 8.0),
              MoonMenuItem(
                onTap: () {},
                height: 32,
                borderRadius: context.moonBorders?.interactiveXs,
                menuItemPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                label: Text(
                  'Stores',
                  style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.trunks),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  MoonTextInput(
                    width: 250,
                    textInputSize: MoonTextInputSize.sm,
                    backgroundColor: context.moonColors?.gohan,
                    leading: MoonIcon(
                      MoonIcons.generic_search_16_light,
                      size: 16.0,
                      color: context.moonColors?.trunks,
                    ),
                    hintText: 'Search game by name or id',
                    activeBorderColor: context.moonColors?.bulma,
                  ),
                  const SizedBox(width: 16.0),
                  MoonTextInput(
                    width: 180,
                    textInputSize: MoonTextInputSize.sm,
                    backgroundColor: context.moonColors?.gohan,
                    controller: TextEditingController(text: 'All Games'),
                    activeBorderColor: context.moonColors?.bulma,
                  ),
                  const Expanded(child: SizedBox(width: 32.0)),
                  MoonFilledButton(
                    label: const Text('Create new game'),
                    onTap: () {
                      _drawerKey.currentState?.openEndDrawer();
                    },
                    buttonSize: MoonButtonSize.sm,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.maxFinite,
                child: PaginatedDataTable(
                  rowsPerPage: 12,
                  headingRowColor: MaterialStatePropertyAll(context.moonColors?.heles),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Age'),
                    ),
                    DataColumn(
                      label: Text('Role'),
                    ),
                  ],
                  source: dataSource,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _showNotifications = false;
  Widget notificationButton() {
    return MoonPopover(
      contentPadding: EdgeInsets.zero,
      backgroundColor: context.moonColors?.gohan,
      popoverPosition: MoonPopoverPosition.bottomLeft,
      borderRadius: context.moonBorders?.interactiveSm,
      show: _showNotifications,
      onTapOutside: () => setState(() => _showNotifications = false),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 380, minWidth: 280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(bottom: 4.0),
              child: Text('Notifications', style: MoonTypography.typography.heading.text14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MoonTabBar(
                          gap: 16.0,
                          tabs: [
                            MoonTab(
                              tabStyle: MoonTabStyle(
                                tabPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                selectedTextColor: context.moonColors?.textPrimary,
                                textColor: context.moonColors?.textSecondary,
                                indicatorColor: context.moonColors?.textPrimary,
                              ),
                              label: Text('Inbox'),
                            ),
                            MoonTab(
                              tabStyle: MoonTabStyle(
                                tabPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                selectedTextColor: context.moonColors?.textPrimary,
                                textColor: context.moonColors?.textSecondary,
                                indicatorColor: context.moonColors?.textPrimary,
                              ),
                              label: Text('Archived'),
                            ),
                          ],
                        ),
                      ),
                      MoonButton.icon(
                        onTap: () {},
                        iconColor: context.moonColors?.trunks,
                        buttonSize: MoonButtonSize.sm,
                        icon: MoonIcon(
                          MoonIcons.software_settings_16_light,
                          size: 16.0,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            Container(
              color: context.moonColors?.goku,
              height: 400,
              margin: EdgeInsets.all(1),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoonIcon(
                    MoonIcons.mail_box_32_light,
                    size: 32.0,
                    color: context.moonColors?.textSecondary,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'All caught up',
                    style: MoonTypography.typography.heading.text14.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'You will be notified here for any notices on\nyour organizations and projects',
                    textAlign: TextAlign.center,
                    style: MoonTypography.typography.body.text12.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      borderColor: context.moonColors!.beerus,
      child: MoonButton.icon(
        onTap: () => setState(() => _showNotifications = true),
        backgroundColor: _showNotifications ? context.moonColors?.heles : null,
        icon: const MoonIcon(MoonIcons.mail_box_24_regular),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
    );
  }

  Widget _createNewGame() {
    return Scaffold(
      backgroundColor: context.moonColors?.gohan,
      appBar: AppBar(
        title: const Text('Create a new game'),
        backgroundColor: context.moonColors?.gohan,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.moonColors!.beerus),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MoonFilledButton(
              onTap: () {},
              buttonSize: MoonButtonSize.sm,
              backgroundColor: context.moonColors?.gohan,
              label: Text('Cancel'),
            ),
            const SizedBox(width: 16.0),
            MoonFilledButton(
              onTap: () {},
              buttonSize: MoonButtonSize.sm,
              label: Text('Save'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: MoonTypography.typography.body.text14.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const MoonTextInput(),
                  const SizedBox(height: 16.0),
                  Text(
                    'Description',
                    style: MoonTypography.typography.body.text14.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const MoonTextInput(hintText: 'Optional'),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MoonAlert(
                show: true,
                showBorder: true,
                borderColor: context.moonColors?.beerus,
                backgroundColor: context.moonColors?.goku,
                leading: MoonIcon(
                  MoonIcons.notifications_alert_16_light,
                  color: context.moonColors?.trunks,
                ),
                label: const Text('Police are required to query data'),
                content: Padding(
                  padding: const EdgeInsets.only(left: 34.0),
                  child: Text(
                    'You need to write an access policy before you can query data from this table. Without a policy, querying this table will result in an empty array of results.\n\nYou can create policies after you create this table.',
                    style: MoonTypography.typography.body.text12.copyWith(
                      color: context.moonColors?.textSecondary,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PagePanelBuilder extends StatefulWidget {
  final Widget bodyPanel;
  final Widget body;
  const PagePanelBuilder({required this.bodyPanel, required this.body, super.key});

  @override
  State<PagePanelBuilder> createState() => _PagPaneleBuilderState();
}

class _PagPaneleBuilderState extends State<PagePanelBuilder> {
  final ScrollController _scrollControllerHorizontal = ScrollController();
  final ScrollController _scrollControllerVertical = ScrollController();

/*   bool _isExpanded = true;
  bool _isVisiblePanel = true; */

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(dividerThickness: 3),
      child: MultiSplitView(
        axis: Axis.horizontal,
        initialAreas: [
          Area(size: 280.0),
          Area(minimalWeight: 0.80),
        ],
        dividerBuilder: (axis, index, resizable, dragging, highlighted, themeData) {
          return const VerticalDivider(thickness: 1);
        },
        children: [
          Visibility(
            child: OverflowBox(
              minWidth: 250,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Game database'),
                ),
                body: widget.bodyPanel,
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(),
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ConstrainedBox(
                    constraints: constraints.copyWith(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                    child: Scrollbar(
                      controller: _scrollControllerVertical,
                      child: Scrollbar(
                        controller: _scrollControllerHorizontal,
                        notificationPredicate: (notif) => notif.depth == 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            controller: _scrollControllerVertical,
                            child: SingleChildScrollView(
                              controller: _scrollControllerHorizontal,
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth > 1300
                                      ? constraints.maxWidth
                                      : constraints.maxWidth < 1300 && constraints.maxWidth > 720
                                          ? constraints.maxWidth
                                          : 720,
                                ),
                                child: widget.body,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  @override
  int get rowCount => 3;

  @override
  DataRow? getRow(int index) {
    switch (index) {
      case 0:
        return DataRow(
          onLongPress: () {},
          cells: const <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
          ],
        );
      case 1:
        return DataRow(
          onLongPress: () {},
          cells: const <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
          ],
        );
      case 2:
        return DataRow(
          onLongPress: () {},
          cells: const <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        );
      case 3:
        return DataRow(
          onLongPress: () {},
          cells: const <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        );

      default:
        return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

final DataTableSource dataSource = MyDataSource();
