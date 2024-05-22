import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:superfrog/utils/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              MoonMenuItem(
                backgroundColor: context.moonColors?.gohan,
                leading: const Icon(MoonIcons.other_water_24_light),
                label: const Text('Theme'),
                trailing: MoonSwitch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) => context.read<ThemeProvider>().toggleTheme(),
                ),
                onTap: () => context.read<ThemeProvider>().toggleTheme(),
              ),
              const SizedBox(height: 8.0),
              MoonMenuItem(
                backgroundColor: context.moonColors?.gohan,
                leading: const Icon(MoonIcons.generic_globe_24_light),
                label: const Text('Language'),
                trailing: Text(context.locale.name),
                onTap: () => showMoonModal(
                  context: context,
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.all(64.0),
                      child: MoonModal(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select Language',
                                        style: MoonTypography.typography.heading.text14,
                                      ),
                                    ),
                                    MoonButton.icon(
                                      buttonSize: MoonButtonSize.sm,
                                      icon: const Icon(MoonIcons.controls_close_small_16_light),
                                      onTap: () => context.pop(),
                                    )
                                  ],
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(16.0),
                                itemCount: context.supportedLocales.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                                itemBuilder: (context, index) => MoonMenuItem(
                                  trailing: MoonRadio(
                                    value: context.supportedLocales[index],
                                    groupValue: context.locale,
                                    tapAreaSizeValue: 0,
                                    onChanged: (_) {},
                                  ),
                                  backgroundColor: context.locale == context.supportedLocales[index]
                                      ? context.moonColors?.gohan
                                      : null,
                                  onTap: () => context.setLocale(context.supportedLocales[index]),
                                  label: Text(context.supportedLocales[index].name),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
