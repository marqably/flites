import 'dart:math';

import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class PositioningUtils {
  /// Returns an offset measured from the top left corner of the screen where the
  /// entire overlay will be visible
  static Offset adjustOverlayOffsetToBeVisible({
    required Offset clickedPosition,
    required Size overlaySize,
    required Size screenSize,
  }) {
    final left = min(
      clickedPosition.dx,
      screenSize.width - overlaySize.width - Sizes.p16,
    );

    final top = min(
      clickedPosition.dy,
      screenSize.height - overlaySize.height - Sizes.p16,
    );

    return Offset(left, top);
  }
}
