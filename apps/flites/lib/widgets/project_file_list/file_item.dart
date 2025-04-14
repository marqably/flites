import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

      final isCurrentlySelected = selectedImageId.value == widget.file.id;
      final isCurrentReferenceImage =
          selectedReferenceImages.value.contains(widget.file.id);

      return MouseRegion(
        onEnter: (event) => isHoveredState.value = true,
        onExit: (event) => isHoveredState.value = false,
        child: Container(
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
            color: isCurrentlySelected
                ? context.colors.surface
                : isHovered
                    ? context.colors.surface
                    : Colors.transparent,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              SelectedImageState.setSelectedImage(widget.file.id);
            },
            child: Row(
              children: [
                SvgUtils.isSvg(widget.file.image)
                    ? SvgPicture.memory(
                        widget.file.image,
                        fit: BoxFit.contain,
                        width: Sizes.p24,
                        height: Sizes.p24,
                      )
                    : Image.memory(
                        widget.file.image,
                        fit: BoxFit.contain,
                        width: Sizes.p24,
                        height: Sizes.p24,
                      ),
                if (widget.file.displayName != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.p24,
                        right: Sizes.p16,
                      ),
                      child: Text(
                        widget.file.displayName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (isHovered)
                  Padding(
                    padding: const EdgeInsets.only(left: Sizes.p16),
                    child: Tooltip(
                      message: context.l10n.delete,
                      child: InkWell(
                        onTap: () {
                          SourceFilesState.deleteImage(widget.file.id);
                        },
                        child: const Icon(Icons.delete, size: Sizes.p16),
                      ),
                    ),
                  ),
                if (isCurrentReferenceImage || isHovered)
                  Padding(
                    padding: const EdgeInsets.only(left: Sizes.p16),
                    child: Tooltip(
                      message: context.l10n.toggleVisibility,
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
                          size: Sizes.p16,
                          // color: Colors.grey,
                        ),
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
