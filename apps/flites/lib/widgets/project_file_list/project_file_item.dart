import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/open_project.dart';

class ProjectFileItem extends StatelessWidget {
  ProjectFileItem(
    this.file, {
    super.key,
  });

  final FlitesImage file;
  final isHoveredState = signal<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isHovered = isHoveredState.value;

      final isCurrentlySelected = selectedImage.value == file.id;
      // final isCurrentReferenceImage = selectedReferenceImage.value == file.id;

      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isCurrentlySelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 6,
                )
              : isHovered
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
        ),
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(8),
        child: MouseRegion(
          onEnter: (event) => isHoveredState.value = true,
          onExit: (event) => isHoveredState.value = false,
          child: GestureDetector(
            onTap: () {
              // Check if previous image should be set as new reference
              if (usePreviousImageAsReference.value) {
                final previousImageId = getPreviousImageId(file.id);

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
              //   SelectedImagesController().toggleImageSelection(file.id);
              // } else {
              SelectedImagesController().toggleSingle(file.id);
              // }
            },
            onDoubleTap: () {
              // if (selectedReferenceImage.value != file.id) {
              //   selectedReferenceImage.value = file.id;
              // } else {
              //   selectedReferenceImage.value = null;
              // }
            },
            child: Stack(
              children: [
                Image.memory(
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
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Reference image indicator
                // if (isCurrentReferenceImage)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.white,
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
