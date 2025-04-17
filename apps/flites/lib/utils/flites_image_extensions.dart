import 'dart:ui';
import 'package:flites/types/flites_image.dart';

extension FlitesImageRectCalculator on FlitesImage {
  /// Extension method on [FlitesImage] to calculate the rectangle of the image on the canvas
  ///
  /// [canvasPosition] is the position of the canvas
  /// [canvasScalingFactor] is the scaling factor of the canvas
  Rect calculateRectOnCanvas({
    required Offset canvasPosition,
    required double canvasScalingFactor,
  }) {
    return Rect.fromLTWH(
      (positionOnCanvas.dx * canvasScalingFactor) + canvasPosition.dx,
      (positionOnCanvas.dy * canvasScalingFactor) + canvasPosition.dy,
      (widthOnCanvas * canvasScalingFactor).abs(),
      (heightOnCanvas * canvasScalingFactor).abs(),
    );
  }
}
