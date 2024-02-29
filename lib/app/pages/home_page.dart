import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/splash_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/data/blocs/upload/upload_cubit.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Uuid uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        BlocProvider(
                          create: (_) => UploadCubit(),
                          child: BlocBuilder<UploadCubit, UploadState>(
                            builder: (context, state) {
                              state.whenOrNull(loaded: (val) => print(val.length));
                              return Column(
                                children: [
                                  MoonFilledButton(
                                    onTap: () async {
                                      await FilePicker.platform.pickFiles().then((result) {
                                        if (result != null && result.files.isNotEmpty) {
                                          XFile file = XFile(result.files.first.path!);

                                          context.read<UploadCubit>().addFile(file);
                                        }
                                      });
                                    },
                                    isFullWidth: true,
                                    label: Text('addFile'),
                                  ),
                                  const SizedBox(height: 24.0),
                                  state.maybeWhen(
                                    loaded: (val) => ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: val.length,
                                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                                      itemBuilder: (_, index) {
                                        return ValueListenableBuilder(
                                          valueListenable: val[index].state!,
                                          builder: (context, value, child) {
                                            return MoonAlert(
                                              show: true,
                                              showBorder: true,
                                              borderColor: context.moonColors?.beerus,
                                              backgroundColor: context.moonColors?.gohan,
                                              label: value.when(
                                                onUploadStart: () => Text('onStart'),
                                                onUploadProgress: (val) => Text('onProgress $val'),
                                                onUploadCompleted: () => Text('completed'),
                                              ),
                                              /* SelectableText(
                                                val[index].objectId,
                                              ) */
                                              leading: MoonButton.icon(
                                                buttonSize: MoonButtonSize.sm,
                                                icon: const MoonIcon(MoonIcons.generic_upload_24_light),
                                                onTap: () {
                                                  context.read<UploadCubit>().upload(val[index].objectId);
                                                },
                                              ),
                                              trailing: MoonButton.icon(
                                                buttonSize: MoonButtonSize.sm,
                                                icon: const MoonIcon(MoonIcons.controls_close_small_24_light),
                                                onTap: () {
                                                  context.read<UploadCubit>().removeFile(val[index].objectId);
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    orElse: () => Text('no items'),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
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
}
