import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/widgets/controls/control_header.dart';
import 'package:flites/widgets/project_file_list/canvas_controls_overlay_button.dart';
import 'package:flites/widgets/project_file_list/file_item.dart';
import 'package:flites/widgets/project_file_list/hoverable_widget.dart';
import 'package:flites/widgets/project_file_list/settings_overlay_button.dart';
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
    // TODO: remove this unneeded watch
    return Watch(
      (context) {
        return GestureDetector(
          onTap: () {
            SelectedImageState.clearSelection();
          },
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Sizes.p8),
                bottomLeft: Radius.circular(Sizes.p8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH16,
                Padding(
                  padding: const EdgeInsets.only(
                    top: Sizes.p42,
                    left: Sizes.p16,
                    right: Sizes.p32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ControlHeader(text: context.l10n.tools.toUpperCase()),
                      Row(
                        children: [
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
                    ],
                  ),
                ),
                gapH32,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                  child: Divider(
                    color: context.colors.surface,
                  ),
                ),
                gapH32,
                Padding(
                  padding: const EdgeInsets.only(
                    left: Sizes.p16,
                    right: Sizes.p32,
                  ),
                  child: Row(
                    children: [
                      ControlHeader(text: context.l10n.frames.toUpperCase()),
                      const Spacer(),
                      Tooltip(
                        message: context.l10n.toggleVisibility,
                        child: InkWell(
                          onTap: () {
                            final selectedRowIndex = selectedImageRow.value;
                            final currentRow =
                                projectSourceFiles.value.rows[selectedRowIndex];
                            if (currentRow.images.length <=
                                selectedReferenceImages.value.toSet().length) {
                              selectedReferenceImages.value = [];
                            } else {
                              selectedReferenceImages.value =
                                  currentRow.images.map((e) => e.id).toList();
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
                Flexible(
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 0),
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
                            children: projectSourceFiles
                                .value.rows[selectedImageRow.value].images
                                .asMap()
                                .entries
                                .map((entry) {
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
                              SourceFilesState.reorderImages(
                                  oldIndex, newIndex);
                            },
                          ),
                        ),
                      ),
                      gapH24,
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Sizes.p16),
                        child: Divider(
                          color: context.colors.surface,
                        ),
                      ),
                      gapH16,
                      HoverableWidget(
                        builder: (isHovered) {
                          return GestureDetector(
                            onTap: () {
                              final selectedImageBeforeImport =
                                  selectedImageId.value;

                              SourceFilesState.addImages().then((_) {
                                final imagesInRow = projectSourceFiles
                                    .value.rows[selectedImageRow.value].images;

                                if (imagesInRow.isEmpty) return;

                                SelectedImageState.setSelectedImage(
                                  imagesInRow.last.id,
                                );
                              });

                              SelectedImageRowState.setSelectedImageRow(
                                selectedImageBeforeImport,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                vertical: Sizes.p2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p16,
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
                                  Container(
                                    padding: const EdgeInsets.all(Sizes.p4),
                                    decoration: BoxDecoration(
                                      color: context.colors.surfaceContainerLow,
                                      borderRadius:
                                          BorderRadius.circular(Sizes.p4),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.add,
                                      size: Sizes.p16,
                                      color: context.colors.onSurface,
                                    ),
                                  ),
                                  gapW16,
                                  Text(
                                    context.l10n.addImage,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(Sizes.p16),
                  child: Row(
                    children: [
                      CanvasControlsButton(),
                      gapW16,
                      SettingsOverlayButton(),
                    ],
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
