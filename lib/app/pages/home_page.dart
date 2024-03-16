import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moon_design/moon_design.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:superfrog/app/widgets/menu_button.dart';
import 'package:superfrog/utils/extensions.dart';

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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      endDrawer: MoonDrawer(
        child: _createNewGame(),
      ),
      body: PagePanelBuilder(
        bodyPanel: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: MenuButton(
                  value: 0,
                  groupValue: _selectedIndex,
                  borderRadius: context.moonBorders?.surfaceXs,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  label: Text('Sample Data'),
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.maxFinite,
                child: MenuButton(
                  value: 1,
                  groupValue: _selectedIndex,
                  borderRadius: context.moonBorders?.surfaceXs,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  label: Text('Sample Data'),
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.maxFinite,
                child: MenuButton(
                  value: 2,
                  groupValue: _selectedIndex,
                  borderRadius: context.moonBorders?.surfaceXs,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  label: Text('Sample Data'),
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.maxFinite,
                child: MenuButton(
                  value: 3,
                  groupValue: _selectedIndex,
                  borderRadius: context.moonBorders?.surfaceXs,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                  label: Text('Sample Data'),
                ),
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.maxFinite,
                child: MenuButton(
                  value: 4,
                  groupValue: _selectedIndex,
                  borderRadius: context.moonBorders?.surfaceXs,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                  label: Text('Sample Data'),
                ),
              ),
            ],
          ),
        ),
        body: Container(),
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
        constraints: const BoxConstraints(maxWidth: 380, minWidth: 280),
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
                        icon: const Icon(
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

class _PagPaneleBuilderState extends State<PagePanelBuilder> with SingleTickerProviderStateMixin {
  final ScrollController _scrollControllerHorizontal = ScrollController();
  final ScrollController _scrollControllerVertical = ScrollController();
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _animation = Tween(begin: 1.0, end: 5.0).animate(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return MultiSplitViewTheme(
        data: MultiSplitViewThemeData(dividerThickness: 5),
        child: MultiSplitView(
          axis: Axis.horizontal,
          initialAreas: [Area(size: 280), Area(minimalSize: context.responsiveWhen(constraints.maxWidth - 350, sm: 0))],
          dividerBuilder: (axis, index, resizable, dragging, highlighted, themeData) {
            bool canAnimate = highlighted && !_animationController.isAnimating;
            canAnimate ? _animationController.forward() : _animationController.reverse();

            return AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return VerticalDivider(
                  thickness: _animation.value,
                );
              },
            );
          },
          children: [
            OverflowBox(
              minWidth: 280,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Game database'),
                ),
                body: widget.bodyPanel,
              ),
            ),
            Scaffold(
              appBar: AppBar(),
              body: Scrollbar(
                controller: _scrollControllerVertical,
                child: Scrollbar(
                  controller: _scrollControllerHorizontal,
                  //    notificationPredicate: (notif) => notif.depth == 1,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      controller: _scrollControllerVertical,
                      child: SingleChildScrollView(
                        controller: _scrollControllerHorizontal,
                        scrollDirection: Axis.horizontal,
                        child: widget.body,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
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
