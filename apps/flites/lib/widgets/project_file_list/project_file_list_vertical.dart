import 'package:file_picker/file_picker.dart';
import 'package:flites/states/key_events.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/widgets/buttons/icon_text_button.dart';
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IconTextButton(
                    icon: Icons.add,
                    text: 'Add Images',
                    onPressed: () async {
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
                          images: imagesAndNames.map((e) => e.image!).toList(),
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
                        selectedReferenceImage.value =
                            isCurrentReferenceImage ? null : widget.file.id;
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
