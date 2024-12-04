import 'package:flites/states/key_events.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/get_flite_image.dart';
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
    int i = 0;

    return Watch(
      (context) {
        // final isEmpty = projectSourceFiles.value.isEmpty;

        // if (isEmpty) {
        //   return const Center(
        //       child: Text(
        //           'No files added yet. Drag and drop files anywhere on this page.'));
        // }

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
                      Image(
                        height: 64,
                        image: AssetImage('assets/images/flites_logo.png'),
                      ),
                      SizedBox(width: 32),
                      Text(
                        'Flites',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView(
                    buildDefaultDragHandles: false,
                    scrollDirection: Axis.vertical,
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

                      final currentImages = List<FlitesImage>.from(
                          projectSourceFiles
                              .value); // TODO(Simon): I think we need to clone this list, no? The following code, especially the setting of the value again, looks like it's already working under the assumption that we have to clone.

                      // reorder
                      final image = currentImages.removeAt(oldIndex);
                      currentImages.insert(newIndex, image);

                      projectSourceFiles.value = currentImages;
                    },
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

      final isCurrentlySelected = selectedImage.value.contains(widget.file.id);
      final isCurrentReferenceImage =
          selectedReferenceImage.value == widget.file.id;

      return MouseRegion(
        onEnter: (event) => isHoveredState.value = true,
        onExit: (event) => isHoveredState.value = false,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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

                if (isCurrentlySelected) {
                  selectedReferenceImage.value = null;
                } else {
                  if (previousImageId != null) {
                    selectedReferenceImage.value = previousImageId;
                  } else {
                    selectedReferenceImage.value = null;
                  }
                }
              }

              if (modifierSignal.value.isMainPressed) {
                SelectedImagesController().toggleImageSelection(widget.file.id);
              } else {
                SelectedImagesController().toggleSingle(widget.file.id);
              }
            },
            onDoubleTap: () {
              if (selectedReferenceImage.value != widget.file.id) {
                selectedReferenceImage.value = widget.file.id;
              } else {
                selectedReferenceImage.value = null;
              }
            },
            child: Row(
              children: [
                Image.memory(
                  widget.file.image,
                  fit: BoxFit.contain,
                  width: 48,
                  height: 48,
                ),
                if (widget.file.name != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text(
                        widget.file.name!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                const Spacer(),
                if (isHovered)
                  IconButton(
                    onPressed: () {
                      projectSourceFiles.value = [...projectSourceFiles.value]
                        ..removeWhere((e) => e.id == widget.file.id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                if (isCurrentReferenceImage || isHovered)
                  IconButton(
                      onPressed: () {
                        selectedReferenceImage.value =
                            isCurrentReferenceImage ? null : widget.file.id;
                      },
                      icon: const Icon(
                        CupertinoIcons.eye_solid,
                        // color: Colors.grey,
                      ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
