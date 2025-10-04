import 'dart:ui';

import '../core/app_state.dart';

/// Legacy compatibility layer for CanvasController
/// This class provides backward compatibility while using the new centralized state
class CanvasController {
  // Private constructor to prevent instantiation
  CanvasController._();

  /// Get whether bounding border is visible
  static bool get showBoundingBorder => appState.showBoundingBorder.value;

  /// Get canvas scaling factor
  static double get canvasScalingFactor => appState.canvasScalingFactor.value;

  /// Get canvas position
  static Offset get canvasPosition => appState.canvasPosition.value;

  /// Get canvas size in pixels
  static Size get canvasSizePixel => appState.canvasSizePixel.value;

  /// Toggle bounding border visibility
  static void toggleBoundingBorder() {
    appState.toggleBoundingBorder();
  }

  /// Update canvas position
  static void updateCanvasPosition(Offset offset) {
    appState.updateCanvasPosition(offset);
  }

  /// Update canvas size
  static void updateCanvasSize(Size size) {
    appState.updateCanvasSize(size);
  }

  /// Update canvas scale
  static void updateCanvasScale({
    required bool isIncreasingSize,
    Offset offsetFromCenter = Offset.zero,
    bool zoomingWithButtons = false,
  }) {
    appState.updateCanvasScale(
      offsetFromCenter: offsetFromCenter,
      isIncreasingSize: isIncreasingSize,
      zoomingWithButtons: zoomingWithButtons,
    );
  }
}
