import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:moon_design/moon_design.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositPage extends StatefulWidget {
  final DepositRouter router;
  const DepositPage(this.router, {super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? MoonButton.icon(
                icon: const Icon(MoonIcons.controls_close_24_regular),
                onTap: () => context.pop(),
              )
            : null,
        actions: [
          MoonButton.icon(
            icon: const Icon(MoonIcons.generic_info_alternative_24_regular),
            onTap: () {},
          ),
          MoonButton.icon(
            icon: const Icon(MoonIcons.time_time_24_regular),
            onTap: () {},
          ),
          const SizedBox(width: 8.0)
        ],
      ),
      body: switch (widget.router) {
        _ => const _DepositCrypto(),
      },
    );
  }
}

class _DepositCrypto extends StatelessWidget {
  const _DepositCrypto();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          color: context.moonColors?.goku,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: MoonFilledButton(
                  backgroundColor: context.moonColors?.gohan,
                  label: const Text('Save Image'),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: MoonFilledButton(
                  label: const Text('Share Address'),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              MoonButton(
                buttonSize: MoonButtonSize.lg,
                label: const Text('Deposit LTC'),
                trailing: const Icon(MoonIcons.controls_chevron_down_small_16_light),
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              QrImageView(
                size: 200,
                data: 'MGxNPPB7eBoWPUaprtX9v9CXJZoD2465zN',
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: context.moonColors?.bulma,
                ),
                embeddedImage: const NetworkImage(
                  'https://eimayatnkgnhsgkjsaom.supabase.co/storage/v1/object/public/colo/assets/litecoin-ltc-logo.png',
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: context.moonColors?.bulma,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'For LTC deposit only',
                style: MoonTypography.typography.body.text12.copyWith(
                  color: context.moonColors?.textSecondary,
                ),
              ),
              const SizedBox(height: 32.0),
              MoonMenuItem(
                backgroundColor: context.moonColors?.gohan,
                label: Text(
                  'Network',
                  style: TextStyle(color: context.moonColors?.textSecondary),
                ),
                trailing: const Icon(MoonIcons.controls_chevron_right_small_16_light),
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'LTC',
                      style: MoonTypography.typography.body.text16.copyWith(
                        color: context.moonColors?.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Litecoin(LTC)',
                      style: MoonTypography.typography.body.text12,
                    )
                  ],
                ),
                onTap: () {},
              ),
              const SizedBox(height: 12.0),
              MoonMenuItem(
                backgroundColor: context.moonColors?.gohan,
                label: Text(
                  'Address',
                  style: TextStyle(color: context.moonColors?.textSecondary),
                ),
                trailing: const Icon(MoonIcons.controls_chevron_right_small_16_light),
                content: Text(
                  'MGxNPPB7eBoWPUaprtX9v9CXJZoD2465zN',
                  style: MoonTypography.typography.body.text16.copyWith(
                    color: context.moonColors?.textPrimary,
                  ),
                ),
                onLongPress: () {
                  Clipboard.setData(
                    const ClipboardData(text: 'MGxNPPB7eBoWPUaprtX9v9CXJZoD2465zN'),
                  );
                  HapticFeedback.vibrate();
                  MoonToast.show(
                    context,
                    toastAlignment: Alignment.topCenter,
                    label: const Text('Wallet Address copied'),
                  );
                },
                onTap: () {},
              ),
              const SizedBox(height: 12.0),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.moonColors?.gohan,
                  borderRadius: MoonBorders.borders.surfaceSm,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DefaultTextStyle(
                    style: MoonTypography.typography.body.text14,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Deposit to',
                              style: TextStyle(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 16.0)),
                            const Text(
                              'Founding Account',
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              'Min Deposit',
                              style: TextStyle(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 16.0)),
                            const Text(
                              '0.00000546 LTC',
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              'Deposit Confirmation',
                              style: TextStyle(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 16.0)),
                            const Text(
                              '5 Block(s)',
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              'Withdrawal Confirmation',
                              style: TextStyle(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                            const Expanded(child: SizedBox(width: 16.0)),
                            const Text(
                              '7 Block(s)',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DepositRouter { crypto, fiat }
