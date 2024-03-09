import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/splash_page.dart';
import 'package:superfrog/config/preference_config.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MoonBreadcrumb(
          divider: Icon(
            Directionality.of(context) == TextDirection.ltr
                ? MoonIcons.controls_chevron_right_small_16_light
                : MoonIcons.controls_chevron_left_small_16_light,
          ),
          items: List.generate(
            6,
            (int index) {
              return MoonBreadcrumbItem(
                onTap: () {},
                label: Text('Page $index'),
              );
            },
          ),
        ),
        actions: [
          notificationButton(),
          const SizedBox(
            width: 16.0,
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: CommonBloc.authenticationBloc,
          builder: (context, state) {
            return state.maybeWhen(
              authenticated: (user) => Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.responsiveWhen(480, sm: double.maxFinite),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.moonColors!.beerus),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ID',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user!.id),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Provider',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user.identities![0].provider),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Email',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user.email!),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Last signed in',
                                      style: MoonTypography.typography.body.text14.copyWith(
                                        color: context.moonColors?.trunks,
                                      ),
                                    ),
                                  ),
                                  Text(user.lastSignInAt!),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        MoonFilledButton(
                          isFullWidth: true,
                          onTap: () => context.read<AuthenticationBloc>().add(const AuthenticationEvent.signOut()),
                          label: const Text('Sign Out'),
                        ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                ),
              ),
              orElse: () => const SplashPage(),
            );
          },
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
        icon: MoonIcon(MoonIcons.mail_box_24_regular),
        iconColor: context.moonColors?.trunks,
        hoverTextColor: context.moonColors?.textPrimary,
      ),
    );
  }
}
