import 'package:file_picker/file_picker.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/widgets/buttons/icon_text_button.dart';
import 'package:flites/widgets/controls/checkbox_button.dart';
import 'package:flites/widgets/controls/control_header.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flites/widgets/upload_area/file_drop_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

enum Tool {
  canvas,
  move,
  rotate,
}

final selectedToolSignal = signal(Tool.canvas);
final hoveredToolSignal = signal<Tool?>(null);

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
                      // Image(
                      //   height: 64,
                      //   image: AssetImage('assets/images/flites_logo.png'),
                      // ),
                      // SizedBox(width: 32),
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
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                  child: Row(
                    children: [
                      ControlHeader(text: 'Tools'),
                      const Spacer(),
                      ToolButton(
                        tool: Tool.canvas,
                        icon: CupertinoIcons.square_split_2x2,
                      ),
                      const SizedBox(width: 16),
                      ToolButton(
                        tool: Tool.move,
                        icon: CupertinoIcons.move,
                      ),
                      const SizedBox(width: 16),
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
                      ControlHeader(text: 'Frames'),
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
                          // color: Colors.grey,
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

                    final currentImages = List<FlitesImage>.from(projectSourceFiles
                        .value); // TODO(Simon): I think we need to clone this list, no? The following code, especially the setting of the value again, looks like it's already working under the assumption that we have to clone.

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
                        print('### on tap');
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

                            print('### 1');

                            return 0;
                          });

                          print('### 2');

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
                            vertical: 2, horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              isHovered ? Colors.grey[200] : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.add,
                              size: 16,
                              color: const Color.fromARGB(255, 26, 26, 26),
                            ),
                            const SizedBox(width: 16),
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
                      child: Icon(
                        CupertinoIcons.layers,
                        color: const Color.fromARGB(255, 29, 29, 29),
                      ),
                    ),
                    overlayContent: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 280,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ControlHeader(text: 'Canvas Controls'),
                            CheckboxButton(
                              text: 'Use Previos Frame as Reference',
                              value: usePreviousImageAsReference,
                            ),
                            CheckboxButton(
                              text: 'Show bounding border',
                              value: showBoundingBorderSignal,
                            ),
                            const SizedBox(height: 32),
                            ControlHeader(text: 'Image Controls'),
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

class FileItem extends StatefulWidget {
  const FileItem({super.key, required this.file});

  final FlitesImage file;

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  final isHoveredState = signal<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isHovered = isHoveredState.value;

      final isCurrentlySelected = selectedImage.value == widget.file.id;
      final isCurrentReferenceImage =
          selectedReferenceImages.value.contains(widget.file.id);

      return MouseRegion(
        onEnter: (event) => isHoveredState.value = true,
        onExit: (event) => isHoveredState.value = false,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isCurrentlySelected
                ? Theme.of(context).primaryColor.withOpacity(0.3)
                : isHovered
                    ? Colors.grey[200]
                    : Colors.transparent,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Check if previous image should be set as new reference
              if (usePreviousImageAsReference.value) {
                final previousImageId = getPreviousImageId(widget.file.id);

                // if (isCurrentlySelected) {
                //   selectedReferenceImage.value = null;
                // } else {
                //   if (previousImageId != null) {
                //     selectedReferenceImage.value = previousImageId;
                //   } else {
                //     selectedReferenceImage.value = null;
                //   }
                // }
              }

              // if (modifierSignal.value.isMainPressed) {
              //   SelectedImagesController().toggleImageSelection(widget.file.id);
              // } else {
              SelectedImagesController().toggleSingle(widget.file.id);
              // }
            },
            onDoubleTap: () {
              // if (selectedReferenceImage.value != widget.file.id) {
              //   selectedReferenceImage.value = widget.file.id;
              // } else {
              //   selectedReferenceImage.value = null;
              // }
            },
            child: Row(
              children: [
                Image.memory(
                  widget.file.image,
                  fit: BoxFit.contain,
                  width: 24,
                  height: 24,
                ),
                if (widget.file.displayName != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16),
                      child: Text(
                        widget.file.displayName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (isHovered)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        projectSourceFiles.value = [...projectSourceFiles.value]
                          ..removeWhere((e) => e.id == widget.file.id);
                      },
                      child: const Icon(Icons.delete, size: 16),
                    ),
                  ),
                if (isCurrentReferenceImage || isHovered)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        if (isCurrentReferenceImage) {
                          selectedReferenceImages.value =
                              selectedReferenceImages.value
                                  .where((e) => e != widget.file.id)
                                  .toList();
                        } else {
                          selectedReferenceImages.value = [
                            ...selectedReferenceImages.value,
                            widget.file.id
                          ];
                        }
                      },
                      child: const Icon(
                        CupertinoIcons.eye_solid,
                        size: 16,
                        // color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class HoverableWidget extends StatefulWidget {
  HoverableWidget({super.key, required this.builder});

  final Widget Function(bool isHovered) builder;

  @override
  State<HoverableWidget> createState() => _HoverableWidgetState();
}

class _HoverableWidgetState extends State<HoverableWidget> {
  final Signal<bool> isHoveredSignal = signal(false);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => isHoveredSignal.value = true,
      onExit: (event) => isHoveredSignal.value = false,
      child: Watch((context) {
        return widget.builder(isHoveredSignal.value);
      }),
    );
  }
}

class ToolButton extends StatelessWidget {
  const ToolButton({super.key, required this.tool, required this.icon});
  final Tool tool;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final selectedTool = selectedToolSignal.value;
      final hoveredTool = hoveredToolSignal.value;

      final isSelected = selectedTool == tool;
      final isHovered = hoveredTool == tool;

      return InkWell(
        onHover: (value) {
          hoveredToolSignal.value = value ? tool : null;
        },
        onTap: () {
          selectedToolSignal.value = tool;
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 96, 96, 96)
                : isHovered
                    ? const Color.fromARGB(255, 185, 185, 185)
                    : const Color.fromARGB(0, 19, 255, 188),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      );
    });
  }
}

class OverlayButton extends StatefulWidget {
  final Widget buttonChild;
  final Widget overlayContent;

  const OverlayButton({
    Key? key,
    required this.buttonChild,
    required this.overlayContent,
  }) : super(key: key);

  @override
  _OverlayButtonState createState() => _OverlayButtonState();
}

class _OverlayButtonState extends State<OverlayButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    // If overlay is already showing, do nothing
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismissible area
          GestureDetector(
            onTap: _hideOverlay, // Hide overlay when tapped outside
            behavior:
                HitTestBehavior.opaque, // Ensures tap is registered anywhere
            child: Container(
              color: Colors.transparent, // Transparent overlay background
            ),
          ),
          // Positioned overlay
          Positioned(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              followerAnchor: Alignment.bottomLeft,
              offset: const Offset(32, 0),
              child: Material(
                elevation: 4.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                child: widget.overlayContent,
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        },
        child: widget.buttonChild,
      ),
    );
  }
}
