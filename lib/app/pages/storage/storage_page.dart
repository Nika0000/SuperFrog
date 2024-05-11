import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mime_type/mime_type.dart';
import 'package:moon_design/moon_design.dart';
import 'package:superfrog/data/blocs/storage/file_upload/file_upload_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

Future<void> createFolder(BuildContext context) async {
  showMoonModal<String>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController controller = TextEditingController();
      return MoonModal(
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 64,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create folder', style: MoonTypography.typography.heading.text16),
                  Text(
                    'Please enter a folder name without extenstions',
                    style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.textSecondary),
                  ),
                  const SizedBox(height: 16.0),
                  MoonTextInput(
                    controller: controller,
                    hintText: 'Folder name',
                    onSubmitted: (folderName) => context.pop(folderName),
                  ),
                  const SizedBox(height: 16.0),
                  MoonFilledButton(
                    isFullWidth: true,
                    label: const Text('Create'),
                    onTap: () {
                      context.pop(controller.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).then((folderName) {
    if (folderName != null) context.read<StorageBloc>().add(StorageEvent.createDirectory(name: folderName));
  });
}

class _StoragePageState extends State<StoragePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        context.watch<StorageBloc>().state.maybeWhen(
              loading: () => MoonLinearProgressIndicator(
                minHeight: 2,
                backgroundColor: context.moonColors!.goku,
                color: context.moonColors!.piccolo,
              ),
              orElse: () => const SizedBox(height: 2),
            ),
        BlocBuilder<StorageBloc, StorageState>(
          buildWhen: (previous, current) {
            String? previousPath = previous.whenOrNull(loaded: (_, directory) => directory);
            String? currentPath = current.whenOrNull(loaded: (_, directory) => directory);

            return previousPath == null || currentPath == previousPath;
          },
          builder: (context, state) {
            return state.maybeWhen(
              unitialized: () {
                context.read<StorageBloc>().add(const StorageEvent.goDirectory(''));
                return const SizedBox();
              },
              loaded: (files, directory) => ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          const Text('Path: /'),
                          const Expanded(child: SizedBox(width: 32.0)),
                          MoonOutlinedButton(
                            borderColor: context.moonColors?.beerus,
                            buttonSize: MoonButtonSize.sm,
                            leading: Icon(
                              MoonIcons.controls_plus_16_light,
                              color: context.moonColors?.textSecondary,
                              size: 16.0,
                            ),
                            label: Text(
                              'Upload File',
                              style: MoonTypography.typography.body.text12.copyWith(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                            onTap: () async {
                              await FilePicker.platform.pickFiles(allowMultiple: true).then(
                                (result) {
                                  if (result != null) {
                                    for (XFile file in result.xFiles) {
                                      context.read<FileUploadBloc>().add(
                                            FileUploadEvent.uploadFile(file, path: ""),
                                          );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 16.0),
                          MoonOutlinedButton(
                            borderColor: context.moonColors?.beerus,
                            buttonSize: MoonButtonSize.sm,
                            leading: Icon(
                              MoonIcons.files_folder_open_alternative_16_light,
                              color: context.moonColors?.textSecondary,
                              size: 16.0,
                            ),
                            label: Text(
                              'Create Folder',
                              style: MoonTypography.typography.body.text12.copyWith(
                                color: context.moonColors?.textSecondary,
                              ),
                            ),
                            onTap: () {
                              createFolder(context);
                            },
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: files.length,
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 4.0,
                        ),
                        itemBuilder: (context, index) => MoonMenuItem(
                          backgroundColor: context.moonColors?.gohan,
                          leading: convertExtensionToIcon(files[index].name),
                          label: Text(files[index].name),
                          trailing: Row(
                            children: [
                              MoonButton.icon(
                                buttonSize: MoonButtonSize.sm,
                                icon: const Icon(MoonIcons.files_remove_16_light),
                                iconColor: context.moonColors?.textSecondary,
                                onTap: () {
                                  context.read<StorageBloc>().add(
                                        StorageEvent.deleteFileOrFolder([files[index]]),
                                      );
                                },
                              ),
                              MoonButton.icon(
                                buttonSize: MoonButtonSize.sm,
                                icon: const Icon(MoonIcons.generic_info_16_light),
                                iconColor: context.moonColors?.textSecondary,
                                onTap: () async {},
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              error: (error) {
                MoonToast.show(context, label: Text(error));
                context.read<StorageBloc>().add(const StorageEvent.goDirectory(''));
                return const SizedBox();
              },
              orElse: () => MoonLinearProgressIndicator(
                minHeight: 2,
                backgroundColor: context.moonColors!.goku,
                color: context.moonColors!.piccolo,
              ),
            );
          },
        ),
      ],
    );
  }

  Icon convertExtensionToIcon(String fileName) {
    final mimetype = mime(fileName);
    return switch (mimetype) {
      'image/jpeg' => const Icon(MoonIcons.media_jpg_24_light),
      'image/png' => const Icon(MoonIcons.media_png_24_light),
      null => const Icon(MoonIcons.files_folder_closed_24_light),
      _ => const Icon(MoonIcons.files_code_24_light)
    };
  }
}
