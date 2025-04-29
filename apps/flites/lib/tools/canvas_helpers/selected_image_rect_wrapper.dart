import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/flites_image_extensions.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Displays the current selection in canvas mode
class SelectedImageRectWrapper extends StatelessWidget {
  const SelectedImageRectWrapper({super.key, required this.builder});

  final Widget Function(FlitesImage currentSelection, Rect selectedImageRect)
      builder;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final currentSelection = getFliteImage(selectedImageId.value);

        final selectedImageRect = currentSelection?.calculateRectOnCanvas(
          canvasPosition: canvasPosition.value,
          canvasScalingFactor: canvasScalingFactor.value,
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
}
