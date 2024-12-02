import 'package:flites/types/flites_image.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/open_project.dart';

class ProjectFileItem extends StatelessWidget {
  const ProjectFileItem(
    this.file, {
    super.key,
  });

  final FlitesImage file;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isCurrentEditorImage = selectedImage.value == file.id;
      final isCurrentReferenceImage = selectedReferenceImage.value == file.id;

      return Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrentEditorImage
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            if (selectedImage.value == file.id) {
              selectedImage.value = null;
            } else {
              selectedImage.value = file.id;
            }
          },
          onDoubleTap: () {
            if (selectedReferenceImage.value != file.id) {
              selectedReferenceImage.value = file.id;
            } else {
              selectedReferenceImage.value = null;
            }
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
              if (isCurrentEditorImage)
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
              if (isCurrentReferenceImage)
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
      );
    });
  }
}
