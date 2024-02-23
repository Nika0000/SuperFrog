import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/app/pages/splash_page.dart';
import 'package:superfrog/data/blocs/authentication/authentication_bloc.dart';
import 'package:superfrog/data/blocs/common_bloc.dart';
import 'package:superfrog/data/blocs/file/file_cubit.dart';
import 'package:superfrog/utils/extensions.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uri resumeUrl = Uri();
  final Uuid uuid = const Uuid();
  XFile uploadFile = XFile("/data/user/0/com.example.superfrog/cache/file_picker/1000005349.mp4");

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
                        MoonFilledButton(
                          isFullWidth: true,
                          onTap: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.media,
                              allowMultiple: true,
                            );
                            if (result != null && result.files.isNotEmpty) {
                              List<XFile> files;

                              files = result.files.map((PlatformFile file) {
                                if (kIsWeb) {
                                  return XFile.fromData(
                                    file.bytes!,
                                    name: file.name,
                                    mimeType: lookupMimeType(file.name),
                                  );
                                } else {
                                  return XFile(
                                    file.path!,
                                    mimeType: lookupMimeType(file.path!),
                                  );
                                }
                              }).toList();

                              print(files.first.path);
                              setState(() {
                                uploadFile = files.first;
                              });
                              // CommonBloc.storageBloc.add(StorageEvent.addFilesToQueue(files: files));
                            }
                          },
                          label: const Text('Add files to queue'),
                        ),
                        /*  const SizedBox(height: 24.0),
                            BlocProvider<FileCubit>(
                              create: (context) => FileCubit(objectId: uuid.v4(), file: uploadFile)..uploadFile(),
                              child: BlocBuilder<FileCubit, FileState>(
                                builder: (context, fileState) {
                                  return MoonAlert(
                                    show: true,
                                    showBorder: true,
                                    borderColor: context.moonColors?.beerus,
                                    backgroundColor: context.moonColors?.gohan,
                                    leading: MoonButton.icon(
                                      onTap: () {
                                        context.read<FileCubit>().pause();
                                      },
                                      icon: const MoonIcon(MoonIcons.generic_upload_24_light),
                                    ),
                                    trailing: MoonButton.icon(
                                      onTap: () {
                                        context.read<FileCubit>().resume();
                                      },
                                      icon: const MoonIcon(MoonIcons.generic_upload_24_light),
                                    ),
                                    label: fileState.when(
                                      initial: () => Text('initial'),
                                      onStart: () => Text('started'),
                                      onProgress: (progress) => Text('onprogress: $progress '),
                                      onCompleted: () => Text('onCompleted'),
                                      onPaused: () => Text('Paused'),
                                      onError: (error) => Text('error $error'),
                                    ),
                                  );
                                },
                              ),
                            ) */
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
