import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../states/canvas_controller.dart';
import '../../../states/selected_image_state.dart';
import '../../../types/flites_image.dart';
import '../../../utils/flites_image_extensions.dart';
import '../../../utils/get_flite_image.dart';

/// Displays the current selection in canvas mode
class SelectedImageRectWrapper extends StatelessWidget {
  const SelectedImageRectWrapper({required this.builder, super.key});

  final Widget Function(FlitesImage currentSelection, Rect selectedImageRect)
      builder;

  @override
  Widget build(BuildContext context) => Watch(
        (context) {
          final currentSelection =
              getFliteImage(SelectedImageState.selectedImageId);

          final selectedImageRect = currentSelection?.calculateRectOnCanvas(
            canvasPosition: CanvasController.canvasPosition,
            canvasScalingFactor: CanvasController.canvasScalingFactor,
          );

          if (currentSelection == null || selectedImageRect == null) {
            return const SizedBox.shrink();
          }
          return builder(
            currentSelection,
            selectedImageRect,
          );
        },
      );
}
