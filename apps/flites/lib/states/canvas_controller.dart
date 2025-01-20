import 'dart:ui';

import 'package:signals/signals_flutter.dart';

/// A controller for managing the canvas state, including the scaling factor,
/// position, size, and visibility of the bounding border.
class CanvasController {
  /// Signal that controls whether the bounding border is visible.
  final showBoundingBorderSignal = signal(false);

  /// Signal that controls the scaling factor of the canvas.
  final _canvasScalingFactorSignal = signal(300.0);

  /// Signal that controls the position of the canvas.
  final _canvasPositionSignal = signal(Offset.zero);

  /// Signal that controls the size of the canvas in pixels.
  final _canvasSizePixelSignal = signal(const Size(1000, 1000));

  // Getters for accessing signal values
  bool get showBoundingBorder => showBoundingBorderSignal.value;
  double get canvasScalingFactor => _canvasScalingFactorSignal.value;
  Offset get canvasPosition => _canvasPositionSignal.value;
  Size get canvasSizePixel => _canvasSizePixelSignal.value;

  /// Toggles the visibility of the bounding border.
  void toggleBoundingBorder() {
    showBoundingBorderSignal.value = !showBoundingBorderSignal.value;
  }

  /// Updates the canvas position by the given offset.
  ///
  /// [offset] The offset to add to the current canvas position.
  void updateCanvasPosition(Offset offset) {
    _canvasPositionSignal.value += offset;
  }

  /// Updates the canvas size to the given size.
  ///
  /// [size] The new size of the canvas.
  void updateCanvasSize(Size size) {
    _canvasSizePixelSignal.value = size;
  }

  /// Updates the canvas scaling factor to the given value.
  ///
  /// [factor] The new scaling factor for the canvas.
  void updateCanvasScalingFactor(double factor) {
    _canvasScalingFactorSignal.value += factor;
  }

  /// Updates the canvas scale by adjusting both the position and scaling factor.
  ///
  /// [offsetFromCenter] The offset from the center of the canvas that affects the scaling.
  /// [isIncreasingSize] Whether the canvas size is increasing (true) or decreasing (false).
  void updateCanvasScale({
    required Offset offsetFromCenter,
    required bool isIncreasingSize,
  }) {
    final scaleFactor = isIncreasingSize ? 1.05 : 0.95;
    final positionDelta = offsetFromCenter * (isIncreasingSize ? -0.05 : 0.05);

    _canvasPositionSignal.value -= positionDelta;
    _canvasScalingFactorSignal.value *= scaleFactor;
  }
}

/// The global canvas controller instance.
final canvasController = CanvasController();
