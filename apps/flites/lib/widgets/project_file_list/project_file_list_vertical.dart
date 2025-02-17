import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/image_picker.dart';
import 'package:flites/widgets/buttons/icon_text_button.dart';
import 'package:flites/widgets/controls/checkbox_button.dart';
import 'package:flites/widgets/controls/control_header.dart';
import 'package:flites/widgets/project_file_list/file_item.dart';
import 'package:flites/widgets/project_file_list/hoverable_widget.dart';
import 'package:flites/widgets/project_file_list/overlay_button.dart';
import 'package:flites/widgets/project_file_list/tool_button.dart';
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
    return Watch(
      (context) {
        return GestureDetector(
          onTap: () {
            SelectedImagesController().clearSelection();
          },
          child: Container(
            width: 300,
            color: context.colors.surfaceContainerLowest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Row(
                    children: [
                      Text(
                        context.l10n.title,
                        style: const TextStyle(
                          fontSize: Sizes.p36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                gapH16,
                Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.p16,
                    right: Sizes.p32,
                  ),
                  child: Row(
                    children: [
                      ControlHeader(text: context.l10n.tools),
                      const Spacer(),
                      ToolButton(
                        tool: Tool.canvas,
                        icon: CupertinoIcons.square_split_2x2,
                        tooltip: context.l10n.canvasMode,
                      ),
                      gapW16,
                      ToolButton(
                        tool: Tool.move,
                        icon: CupertinoIcons.move,
                        tooltip: context.l10n.moveTool,
                      ),
                      gapW16,
                      ToolButton(
                        tool: Tool.rotate,
                        icon: CupertinoIcons.rotate_right,
                        tooltip: context.l10n.rotateTool,
                      ),
                    ],
                  ),
                ),
                gapH8,
                Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.p16,
                    right: Sizes.p32,
                  ),
                  child: Row(
                    children: [
                      ControlHeader(text: context.l10n.frames),
                      const Spacer(),
                      Tooltip(
                        message: context.l10n.toggleVisibility,
                        child: InkWell(
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
                            size: Sizes.p16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView(
                    buildDefaultDragHandles: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    scrollController: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    proxyDecorator: (child, index, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.05,
                            child: Material(
                              color: Colors.transparent,
                              child: child,
                            ),
                          );
                        },
                        child: child,
                      );
                    },
                    children:
                        projectSourceFiles.value.asMap().entries.map((entry) {
                      return ReorderableDragStartListener(
                        key: Key('file-${entry.key}'),
                        index: entry.key,
                        child: FileItem(
                          file: entry.value,
                          key: Key('file-item-${entry.key}'),
                        ),
                      );
                    }).toList(),
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final List<FlitesImage> currentImages =
                          List.from(projectSourceFiles.value);
                      final item = currentImages.removeAt(oldIndex);
                      currentImages.insert(newIndex, item);
                      projectSourceFiles.value = currentImages;
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HoverableWidget(
                      builder: (isHovered) {
                        return GestureDetector(
                          onTap: () async {
                            final newImages =
                                await imagePickerService.pickAndProcessImages();
                            if (newImages.isNotEmpty) {
                              projectSourceFiles.value = [
                                ...projectSourceFiles.value,
                                ...newImages,
                              ];
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              vertical: Sizes.p2,
                              horizontal: Sizes.p8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.p24,
                              vertical: Sizes.p8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Sizes.p8),
                              color: isHovered
                                  ? context.colors.surface
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.add,
                                  size: Sizes.p16,
                                  color: context.colors.surfaceDim,
                                ),
                                gapW16,
                                Text(context.l10n.addImage),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: OverlayButton(
                        tooltip: context.l10n.canvasAndImageControls,
                        buttonChild: Container(
                          padding: const EdgeInsets.all(Sizes.p8),
                          decoration: BoxDecoration(
                            color: context.colors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(Sizes.p8),
                          ),
                          child: Icon(
                            CupertinoIcons.layers,
                            color: context.colors.surfaceDim,
                          ),
                        ),
                        overlayContent: Padding(
                          padding: const EdgeInsets.all(Sizes.p16),
                          child: SizedBox(
                            width: 280,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ControlHeader(
                                    text: context.l10n.canvasControls),
                                CheckboxButton(
                                  text:
                                      context.l10n.usePreviousFrameAsReference,
                                  value: usePreviousImageAsReference,
                                ),
                                CheckboxButton(
                                  text: context.l10n.showBoundingBorder,
                                  value:
                                      canvasController.showBoundingBorderSignal,
                                ),
                                gapH32,
                                ControlHeader(
                                    text: context.l10n.canvasControls),
                                IconTextButton(
                                  onPressed: () {
                                    final images = [
                                      ...projectSourceFiles.value
                                    ];

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
                                  text: context.l10n.sortByName,
                                ),
                                IconTextButton(
                                  onPressed: () {
                                    final images = [
                                      ...projectSourceFiles.value
                                    ];

                                    for (int i = 1; i <= images.length; i++) {
                                      final img = images[i - 1];
                                      img.displayName = 'frame_$i.png';
                                    }

                                    projectSourceFiles.value = images;
                                  },
                                  text:
                                      context.l10n.renameFilesAccordingToOrder,
                                ),
                                IconTextButton(
                                  onPressed: () {
                                    final images = [
                                      ...projectSourceFiles.value
                                    ];

                                    for (int i = 1; i <= images.length; i++) {
                                      final img = images[i - 1];
                                      img.displayName = img.originalName;
                                    }

                                    projectSourceFiles.value = images;
                                  },
                                  text: context.l10n.resetNames,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
