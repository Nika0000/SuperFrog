import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mime_type/mime_type.dart';
import 'package:moon_design/moon_design.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superfrog/data/blocs/storage/file_upload/file_upload_bloc.dart';
import 'package:superfrog/data/blocs/storage/storage_bloc.dart';

import 'package:path/path.dart' as p;
import 'package:superfrog/data/model/file_metadata.dart';
import 'package:superfrog/utils/extensions.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  String currentDir = "";

  Future<void> createFolder() async {
    showMoonModal<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return MoonModal(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: context.responsiveWhen(420, sm: MediaQuery.of(context).size.width - 64),
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
      if (folderName != null) {
        context.read<StorageBloc>().add(
              StorageEvent.createDirectory(
                name: folderName,
                path: p.join(currentDir, folderName),
              ),
            );
      }
    });
  }

  void navigateBack() {
    if (currentDir.isNotEmpty) {
      List<String> dirs = p.split(currentDir);
      String newPath = p.join(dirs.length <= 1 ? "" : dirs.reversed.toList().removeLast());
      setState(() {
        currentDir = newPath;
      });
      context.read<StorageBloc>().add(StorageEvent.goDirectory(currentDir));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void updateDirectory(String newDir) async {
    setState(
      () {
        currentDir = newDir;
        print("currentDir: $currentDir\n");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text('path: '),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: BlocBuilder<StorageBloc, StorageState>(buildWhen: (previous, current) {
                              return current.whenOrNull(loaded: (_, dir) => dir) != null;
                            }, builder: (context, state) {
                              List<String> dirs = p.split(state.whenOrNull(loaded: (_, dir) => dir) ?? "");
                              return MoonBreadcrumb(
                                divider: const Text("/"),
                                items: List.generate(
                                  dirs.length,
                                  (index) => MoonBreadcrumbItem(
                                    onTap: () {
                                      setState(
                                        () {
                                          currentDir = p.joinAll(
                                            dirs.getRange(0, index),
                                          );
                                          context.read<StorageBloc>().add(StorageEvent.goDirectory(currentDir));
                                        },
                                      );
                                    },
                                    label: Text(dirs[index]),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  MoonButton.icon(
                    showBorder: true,
                    borderColor: context.moonColors?.beerus,
                    buttonSize: MoonButtonSize.sm,
                    icon: Icon(
                      MoonIcons.arrows_refresh_round_16_light,
                      color: context.moonColors?.textSecondary,
                      size: 16.0,
                    ),
                    onTap: () {
                      context.read<StorageBloc>().add(StorageEvent.goDirectory(currentDir));
                    },
                  ),
                  const SizedBox(width: 8.0),
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
                                    FileUploadEvent.uploadFile(file, path: currentDir),
                                  );
                            }
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8.0),
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
                      createFolder();
                    },
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            context.watch<StorageBloc>().state.maybeWhen(
                  loaded: (_, dir) {
                    currentDir = dir;
                    return const SizedBox(height: 2);
                  },
                  loading: () => MoonLinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: context.moonColors!.goku,
                    color: context.moonColors!.piccolo,
                  ),
                  orElse: () => const SizedBox(height: 2),
                ),
            BlocBuilder<StorageBloc, StorageState>(
              buildWhen: (previous, current) {
                return current.whenOrNull(loaded: (_, dir) => dir) != null;
              },
              builder: (context, state) {
                return state.whenOrNull(
                        unitialized: () {
                          context.read<StorageBloc>().add(StorageEvent.goDirectory(currentDir));
                          return const SizedBox();
                        },
                        loaded: (files, directory) => files.isEmpty
                            ? Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MoonIcons.files_folder_open_32_light,
                                    size: 48,
                                    color: context.moonColors?.trunks,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Folder is empty',
                                    style: MoonTypography.typography.body.text16.copyWith(
                                      color: context.moonColors?.textSecondary,
                                    ),
                                  ),
                                ],
                              ))
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: files.length,
                                      separatorBuilder: (_, __) => const SizedBox(
                                        height: 4.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        return FileWidget(
                                          file: files[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        error: (error) {
                          MoonToast.show(context, label: Text(error));
                          context.read<StorageBloc>().add(StorageEvent.goDirectory(currentDir));
                          return const SizedBox();
                        }) ??
                    const SizedBox();
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<FileUploadBloc, FileUploadState>(builder: (context, state) {
                bool showDialog = true;
                return state.maybeWhen(
                  unitialized: () => const SizedBox(),
                  orElse: () => MoonAlert.filled(
                    show: state.maybeWhen(
                        fileUploaded: (fileobj) {
                          showDialog = false;
                          return showDialog;
                        },
                        orElse: () => true),
                    backgroundColor: context.moonColors?.gohan,
                    leading: state.maybeWhen(
                      fileUploaded: (_) => Icon(
                        MoonIcons.generic_check_rounded_16_light,
                        color: context.moonColors?.piccolo,
                      ),
                      orElse: () => SizedBox(
                        width: 16,
                        height: 16.0,
                        child: MoonCircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.moonColors!.piccolo,
                          backgroundColor: context.moonColors!.beerus,
                        ),
                      ),
                    ),
                    label: state.maybeWhen(
                      fileUploading: (fileobj) => Text("Uploading ${fileobj.fileName}"),
                      fileUploaded: (fileobj) => Text('File ${fileobj.fileName} uploaded'),
                      orElse: () => const Text("Uploading"),
                    ),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}

class FileWidget extends StatefulWidget {
  final FileObject file;

  const FileWidget({required this.file, super.key});

  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  Icon convertExtensionToIcon(String fileName) {
    final mimetype = mime(fileName);
    return switch (mimetype) {
      'image/jpeg' => const Icon(MoonIcons.media_jpg_24_light),
      'image/png' => const Icon(MoonIcons.media_png_24_light),
      null => const Icon(MoonIcons.files_folder_closed_24_light),
      _ => const Icon(MoonIcons.files_code_24_light)
    };
  }

  void showDeleteDialog() async {
    return showMoonModal<bool>(
      context: context,
      builder: (context) {
        return MoonModal(
          child: SizedBox(
            width: context.responsiveWhen(420, sm: MediaQuery.of(context).size.width - 64),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delete ${isFolder ? "folder" : "file"}', style: MoonTypography.typography.heading.text16),
                  const SizedBox(height: 8.0),
                  Text(
                    'Are you sure to delete ${widget.file.name}?\nThis action cannot be undone.',
                    style: MoonTypography.typography.body.text12.copyWith(color: context.moonColors?.textSecondary),
                  ),
                  const SizedBox(height: 16.0),
                  MoonFilledButton(
                    isFullWidth: true,
                    backgroundColor: context.moonColors?.dodoria,
                    label: const Text('Delete'),
                    onTap: () {
                      return context.pop(true);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then(
      (delete) {
        if (delete == true) {
          context.read<StorageBloc>().add(
                StorageEvent.deleteFileOrFolder(
                  [FileMetadatas(directory: currentDir, fileName: widget.file.name, isDirectory: isFolder)],
                ),
              );
        }
      },
    );
  }

  void showInfoDialog() async {
    return showMoonModal<void>(
      context: context,
      builder: (context) {
        return MoonModal(
          child: SizedBox(
            width: context.responsiveWhen(420, sm: MediaQuery.of(context).size.width - 64),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('File info', style: MoonTypography.typography.heading.text16),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Expanded(child: Text('eTag')),
                      SelectableText(widget.file.metadata?['eTag']),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Expanded(child: Text('Size')),
                      SelectableText("${widget.file.metadata?['size']}"),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Expanded(child: Text('mimetype')),
                      SelectableText(widget.file.metadata?['mimetype']),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Expanded(child: Text('Last modified')),
                      SelectableText(widget.file.metadata?['lastModified']),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  late bool isFolder;

  late String currentDir;

  @override
  void initState() {
    isFolder = widget.file.metadata == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentDir = context.read<StorageBloc>().state.whenOrNull(loaded: (_, dir) => dir) ?? "";
    return Material(
      color: context.moonColors?.gohan,
      borderRadius: MoonSquircleBorderRadius(cornerRadius: 4.0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          if (isFolder) {
            context.read<StorageBloc>().add(StorageEvent.goDirectory(p.join(currentDir, widget.file.name)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              convertExtensionToIcon(widget.file.name),
              const SizedBox(width: 8.0),
              Expanded(child: Text(widget.file.name)),
              MoonButton.icon(
                iconColor: context.moonColors?.textSecondary,
                buttonSize: MoonButtonSize.xs,
                icon: const Icon(MoonIcons.generic_delete_16_light),
                onTap: () {
                  showDeleteDialog();
                },
              ),
              if (!isFolder)
                MoonButton.icon(
                  iconColor: context.moonColors?.textSecondary,
                  buttonSize: MoonButtonSize.xs,
                  icon: const Icon(MoonIcons.generic_info_16_light),
                  onTap: () {
                    showInfoDialog();
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
