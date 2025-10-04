import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signals/signals_flutter.dart';

class ProjectFileItem extends StatelessWidget {
  ProjectFileItem(
    this.file, {
    super.key,
  });

  final FlitesImage file;
  final isHoveredState = signal<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final isHovered = isHoveredState.value;

        final isCurrentlySelected = selectedImageId.value == file.id;

        return Container(
          margin: const EdgeInsets.only(right: Sizes.p8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.p8),
            border: isCurrentlySelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 6,
                  )
                : isHovered
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: Sizes.p2,
                      )
                    : null,
          ),
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(Sizes.p8),
          child: MouseRegion(
            onEnter: (event) => isHoveredState.value = true,
            onExit: (event) => isHoveredState.value = false,
            child: GestureDetector(
              onTap: () {
                SelectedImageState.setSelectedImage(file.id);
              },
              child: Stack(
                children: [
                  SvgUtils.isSvg(file.image)
                      ? SvgPicture.memory(
                          file.image,
                          fit: BoxFit.contain,
                          width: 150,
                          height: 150,
                        )
                      : Image.memory(
                          file.image,
                          fit: BoxFit.contain,
                          width: 150,
                          height: 150,
                        ),

                  // Reference image indicator
                  if (isCurrentlySelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(Sizes.p4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: context.colors.surfaceContainerLowest,
                        ),
                      ),
                    ),

                  // Reference image indicator
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(Sizes.p4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(Sizes.p4),
                      ),
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: context.colors.surfaceContainerLowest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
