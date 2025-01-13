import 'package:file_picker/file_picker.dart';
import 'package:flites/constants/image_constants.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/widgets/buttons/icon_text_button.dart';
import 'package:flites/widgets/controls/checkbox_button.dart';
import 'package:flites/widgets/controls/control_header.dart';
import 'package:flites/widgets/project_file_list/file_item.dart';
import 'package:flites/widgets/project_file_list/hoverable_widget.dart';
import 'package:flites/widgets/project_file_list/overlay_button.dart';
import 'package:flites/widgets/project_file_list/tool_button.dart';
import 'package:flites/widgets/upload_area/file_drop_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ProjectFileListVertical extends StatefulWidget {
  const ProjectFileListVertical({super.key});

  @override
  State<ProjectFileListVertical> createState() =>
      _ProjectFileListVerticalState();
}

class _ProjectFileListVerticalState extends State<ProjectFileListVertical> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO(beau): refactor
    int i = 0;

    return Watch(
      (context) {
        return GestureDetector(
          onTap: () {
            SelectedImagesController().clearSelection();
          },
          child: Container(
            width: 300,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Flites',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 32.0),
                  child: Row(
                    children: [
                      ControlHeader(text: 'Tools'),
                      Spacer(),
                      ToolButton(
                        tool: Tool.canvas,
                        icon: CupertinoIcons.square_split_2x2,
                      ),
                      SizedBox(width: 16),
                      ToolButton(
                        tool: Tool.move,
                        icon: CupertinoIcons.move,
                      ),
                      SizedBox(width: 16),
                      ToolButton(
                        tool: Tool.rotate,
                        icon: CupertinoIcons.rotate_right,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                  child: Row(
                    children: [
                      const ControlHeader(text: 'Frames'),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (projectSourceFiles.value.length <=
                              selectedReferenceImages.value.toSet().length) {
                            selectedReferenceImages.value = [];
                          } else {
                            selectedReferenceImages.value = projectSourceFiles
                                .value
                                .map((e) => e.id)
                                .toList();
                          }
                        },
                        child: const Icon(
                          CupertinoIcons.eye_solid,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ReorderableListView(
                  buildDefaultDragHandles: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  scrollController: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: projectSourceFiles.value.map((file) {
                    i++;
                    return FileItem(
                      file: file,
                      key: Key('file-$i'),
                    );
                  }).toList(),
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }

                    final currentImages =
                        List<FlitesImage>.from(projectSourceFiles.value);

                    // reorder
                    final image = currentImages.removeAt(oldIndex);
                    currentImages.insert(newIndex, image);

                    projectSourceFiles.value = currentImages;
                  },
                ),
                HoverableWidget(
                  builder: (isHovered) {
                    return GestureDetector(
                      onTap: () async {
                        // TODO(beau): refactor, this logic should not live in a widget file
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          withData: true,
                          type: FileType.custom,
                          allowedExtensions: ['png'],
                        );

                        if (result == null) {
                          return;
                        }

                        final imagesAndNames = (await Future.wait(result.files
                                .map(ImageUtils.rawImageFroMPlatformFile)))
                            .whereType<RawImageAndName>()
                            .where((e) => e.image != null && isPng(e.image!))
                            .toList();

                        if (imagesAndNames.isNotEmpty) {
                          final scalingFactor =
                              ImageUtils.getScalingFactorForMultipleImages(
                            images:
                                imagesAndNames.map((e) => e.image!).toList(),
                            sizeLongestSideOnCanvas: defaultSizeOnCanvas,
                          );

                          imagesAndNames.sort((a, b) {
                            if (a.name != null && b.name != null) {
                              return a.name!.compareTo(b.name!);
                            }

                            return 0;
                          });

                          for (final img in imagesAndNames) {
                            final flitesImage = FlitesImage.scaled(img.image!,
                                scalingFactor: scalingFactor,
                                originalName: img.name);

                            projectSourceFiles.value = [
                              ...projectSourceFiles.value,
                              flitesImage,
                            ];
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              isHovered ? Colors.grey[200] : Colors.transparent,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              size: 16,
                              color: Color.fromARGB(255, 26, 26, 26),
                            ),
                            SizedBox(width: 16),
                            Text('Add Image'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OverlayButton(
                    buttonChild: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 244, 244),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        CupertinoIcons.layers,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                    ),
                    overlayContent: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 280,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ControlHeader(text: 'Canvas Controls'),
                            CheckboxButton(
                              text: 'Use Previos Frame as Reference',
                              value: usePreviousImageAsReference,
                            ),
                            CheckboxButton(
                              text: 'Show bounding border',
                              value: canvasController.showBoundingBorderSignal,
                            ),
                            const SizedBox(height: 32),
                            const ControlHeader(text: 'Image Controls'),
                            IconTextButton(
                              onPressed: () {
                                final images = [...projectSourceFiles.value];

                                images.sort((a, b) {
                                  if (a.displayName != null &&
                                      b.displayName != null) {
                                    return a.displayName!
                                        .compareTo(b.displayName!);
                                  }

                                  return 0;
                                });

                                projectSourceFiles.value = images;
                              },
                              text: 'Sort by name',
                            ),
                            IconTextButton(
                              onPressed: () {
                                final images = [...projectSourceFiles.value];

                                for (int i = 1; i <= images.length; i++) {
                                  final img = images[i - 1];
                                  img.displayName = 'frame_$i.png';
                                }

                                projectSourceFiles.value = images;
                              },
                              text: 'Rename Files according to order',
                            ),
                            IconTextButton(
                              onPressed: () {
                                final images = [...projectSourceFiles.value];

                                for (int i = 1; i <= images.length; i++) {
                                  final img = images[i - 1];
                                  img.displayName = img.originalName;
                                }

                                projectSourceFiles.value = images;
                              },
                              text: 'Reset Names',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
