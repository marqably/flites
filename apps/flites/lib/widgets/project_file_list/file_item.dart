import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

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
    // TODO(beau): refactor
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
                ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                : isHovered
                    ? Colors.grey[200]
                    : Colors.transparent,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              SelectedImagesController().toggleSingle(widget.file.id);
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
