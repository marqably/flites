import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/widgets/buttons/icon_text_button.dart';
import 'package:flites/widgets/controls/checkbox_button.dart';
import 'package:flites/widgets/project_file_list/overlay_button.dart';
import 'package:flutter/cupertino.dart';

class CanvasControlsButton extends StatelessWidget {
  const CanvasControlsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayButton(
      tooltip: context.l10n.canvasAndImageControls,
      offset: const Offset(0, -12),
      buttonChild: Container(
        padding: const EdgeInsets.all(Sizes.p8),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Sizes.p8),
        ),
        child: Icon(
          CupertinoIcons.layers,
          color: context.colors.onSurface,
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
              Text(
                context.l10n.canvasControls,
                style: const TextStyle(fontSize: 16),
              ),
              gapH16,
              CheckboxButton(
                text: context.l10n.usePreviousFrameAsReference,
                value: usePreviousImageAsReference,
              ),
              CheckboxButton(
                text: context.l10n.showBoundingBorder,
                value: canvasController.showBoundingBorderSignal,
              ),
              gapH16,
              IconTextButton(
                onPressed: () {
                  final selectedRowIndex = selectedImageRow.value;
                  final images = [
                    ...projectSourceFiles.value.rows[selectedRowIndex].images
                  ];
                  images.sort((a, b) {
                    if (a.displayName != null && b.displayName != null) {
                      return a.displayName!.compareTo(b.displayName!);
                    }
                    return 0;
                  });

                  final newRow = projectSourceFiles.value.rows[selectedRowIndex]
                      .copyWith(images: images);

                  projectSourceFiles.value.rows[selectedRowIndex] = newRow;
                },
                text: context.l10n.sortByName,
              ),
              gapH8,
              IconTextButton(
                onPressed: () {
                  final selectedRowIndex = selectedImageRow.value;
                  final images = [
                    ...projectSourceFiles.value.rows[selectedRowIndex].images
                  ];
                  for (int i = 1; i <= images.length; i++) {
                    final img = images[i - 1];
                    img.displayName = 'frame_$i.png';
                  }
                  projectSourceFiles.value.rows[selectedRowIndex] =
                      projectSourceFiles.value.rows[selectedRowIndex].copyWith(
                    images: images,
                  );
                },
                text: context.l10n.renameFilesAccordingToOrder,
              ),
              gapH8,
              IconTextButton(
                onPressed: () {
                  final selectedRowIndex = selectedImageRow.value;
                  final images = [
                    ...projectSourceFiles.value.rows[selectedRowIndex].images
                  ];
                  for (int i = 1; i <= images.length; i++) {
                    final img = images[i - 1];
                    img.displayName = img.originalName;
                  }
                  projectSourceFiles.value.rows[selectedRowIndex] =
                      projectSourceFiles.value.rows[selectedRowIndex].copyWith(
                    images: images,
                  );
                },
                text: context.l10n.resetNames,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
