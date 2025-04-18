import 'package:flites/states/canvas_controller.dart';
import 'package:flites/tools/canvas_helpers/image_editor.dart';
import 'package:flites/tools/canvas_helpers/selected_image_rect_wrapper.dart';
import 'package:flites/widgets/flites_image_renderer/flites_image_renderer.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flites/widgets/player/player.dart';
import 'package:flites/widgets/rotation/rotation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final rotationSignal = signal<double?>(null);

/// Displays the current selection in rotate mode
class RotateTool extends StatelessWidget {
  const RotateTool({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: ImageEditor(
        stackChildren: const [
          PlayerControls(),
        ],
        child: SelectedImageRectWrapper(
          builder: (
            currentSelection,
            selectedImageRect,
          ) {
            final rotatedImageSize =
                (longestSideSize(selectedImageRect.size) / 2) * 3;

            final rotatedImageOffset = Offset(
              selectedImageRect.left -
                  (rotatedImageSize - selectedImageRect.width) / 2,
              selectedImageRect.top -
                  (rotatedImageSize - selectedImageRect.height) / 2,
            );

            return Positioned(
              top: rotatedImageOffset.dy,
              left: rotatedImageOffset.dx,
              child: RotationWrapper(
                key: ValueKey(
                    currentSelection.id + canvasScalingFactor.toString()),
                rect: selectedImageRect,
                onRotate: (newAngle) {
                  currentSelection.rotation = newAngle;
                },
                initialRotation: currentSelection.rotation,
                child: SizedBox(
                  width: selectedImageRect.width,
                  height: selectedImageRect.height,
                  child: FlitesImageRenderer(flitesImage: currentSelection),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
