import 'dart:ui';

import 'package:signals/signals_flutter.dart';

/// Signal that controls whether the bounding border is visible.
final showBoundingBorderSignal = signal(false);

/// Signal that controls the scaling factor of the canvas.
final _canvasScalingFactorSignal = signal(1.0);

/// Signal that controls the position of the canvas.
final _canvasPositionSignal = signal(Offset.zero);

/// Signal that controls the size of the canvas in pixels.
final _canvasSizePixelSignal = signal(const Size(1000, 1000));

ReadonlySignal<bool> get showBoundingBorder =>
    showBoundingBorderSignal.readonly();
ReadonlySignal<double> get canvasScalingFactor =>
    _canvasScalingFactorSignal.readonly();
ReadonlySignal<Offset> get canvasPosition => _canvasPositionSignal.readonly();
ReadonlySignal<Size> get canvasSizePixel => _canvasSizePixelSignal.readonly();

/// A controller for managing the canvas state, including the scaling factor,
/// position, size, and visibility of the bounding border.
class CanvasController {
  /// Toggles the visibility of the bounding border.
  static void toggleBoundingBorder() {
    showBoundingBorderSignal.value = !showBoundingBorderSignal.value;
  }

  /// Updates the canvas position by the given offset.
  ///
  /// [offset] The offset to add to the current canvas position.
  static void updateCanvasPosition(Offset offset) {
    _canvasPositionSignal.value += offset;
  }

  /// Updates the canvas size to the given size.
  ///
  /// [size] The new size of the canvas.
  static void updateCanvasSize(Size size) {
    if (size == _canvasSizePixelSignal.value) return;
    _canvasSizePixelSignal.value = size;
  }

  /// Updates the canvas scale by adjusting both the position and scaling factor.
  ///
  /// [offsetFromCenter] The offset from the center of the canvas that affects the scaling.
  /// [isIncreasingSize] Whether the canvas size is increasing (true) or decreasing (false).
  static void updateCanvasScale({
    Offset offsetFromCenter = const Offset(0, 0),
    required bool isIncreasingSize,
    bool zoomingWithButtons = false,
  }) {
    final double scaleFactor;

    if (zoomingWithButtons) {
      scaleFactor = isIncreasingSize ? 1.2 : 0.8;
    } else {
      scaleFactor = isIncreasingSize ? 1.05 : 0.95;
    }

    final positionDelta = offsetFromCenter * (isIncreasingSize ? -0.05 : 0.05);

    _canvasPositionSignal.value -= positionDelta;
    _canvasScalingFactorSignal.value *= scaleFactor;
  }
}
