import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/canvas_controller.dart';
import '../../widgets/flites_image_renderer/flites_image_renderer.dart';
import '../../widgets/layout/app_shell.dart';
import '../../widgets/player/player.dart';
import '../../widgets/rotation/rotation_wrapper.dart';
import 'canvas_helpers/image_editor.dart';
import 'canvas_helpers/selected_image_rect_wrapper.dart';

final rotationSignal = signal<double?>(null);

/// Displays the current selection in rotate mode
class RotateTool extends StatelessWidget {
  const RotateTool({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
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
                    currentSelection.id +
                        CanvasController.canvasScalingFactor.toString(),
                  ),
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
