import 'package:flutter/material.dart';

import '../types/scaling_info.dart';

class ImageScalingUtils {
  // Private constructor to prevent instantiation
  ImageScalingUtils._();
  static ScalingInfo calculateImageFit({
    required double imageAspectRatio,
    required double tileAspectRatio,
  }) {
    if (tileAspectRatio <= 0 || imageAspectRatio <= 0) {
      return ScalingInfo.same();
    }

    // Use a small tolerance for floating point comparisons
    const epsilon = 1e-9;

    final Axis paddedAxis;
    final double scalingFactor;

    if ((imageAspectRatio - tileAspectRatio).abs() < epsilon) {
      // Case 3: Aspect ratios are essentially equal
      paddedAxis = Axis.horizontal;

      scalingFactor = 1.0;
    } else if (imageAspectRatio > tileAspectRatio) {
      // Fit to tile width, padding will be vertical.
      paddedAxis = Axis.vertical;

      scalingFactor = tileAspectRatio / imageAspectRatio;
    } else {
      // Case 2: Image is relatively taller/narrower than the tile.
      paddedAxis = Axis.horizontal;

      scalingFactor = imageAspectRatio / tileAspectRatio;
    }

    return ScalingInfo(axis: paddedAxis, factor: scalingFactor);
  }

  static Offset translateOffsetToRelFlameOffset(
    Offset offset,
    ScalingInfo scalingInfo,
  ) {
    final Offset downScaledPoint;

    if (scalingInfo.axis == Axis.horizontal) {
      downScaledPoint = Offset(offset.dx * scalingInfo.factor, offset.dy);
    } else {
      downScaledPoint = Offset(offset.dx, offset.dy * scalingInfo.factor);
    }

    // map 0-1 to -1-1
    return Offset(downScaledPoint.dx * 2 - 1, downScaledPoint.dy * 2 - 1);
  }
}
