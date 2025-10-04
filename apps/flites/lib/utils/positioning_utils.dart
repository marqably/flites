import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class PositioningUtils {
  // Private constructor to prevent instantiation
  PositioningUtils._();
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
