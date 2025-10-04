import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../states/canvas_controller.dart';
import 'svg_utils.dart';

/// A utility class for working with images.
/// Holds methods for scaling images, getting image sizes, and more.
class ImageUtils {
  // Private constructor to prevent instantiation
  ImageUtils._();
  static double getScalingFactorForMultipleImages({
    required List<Uint8List> images,
    required double sizeLongestSideOnCanvas,
  }) {
    try {
      final factors = images.map(
        (e) {
          try {
            return _scaleImageToCanvas(
              e,
              sizeLongerSideOnCanvas: sizeLongestSideOnCanvas,
            );
          } on Exception {
            return 1.0; // Default scaling factor
          }
        },
      ).toList();

      final biggestScaleFactor = factors.fold<double>(
        0,
        (value, element) => value > element ? value : element,
      );

      return biggestScaleFactor > 0 ? biggestScaleFactor : 1.0;
    } on Exception {
      return 1; // Default scaling factor
    }
  }

  static double _scaleImageToCanvas(
    Uint8List rawImage, {
    required double sizeLongerSideOnCanvas,
  }) {
    final size = sizeOfRawImage(rawImage);

    final widthIsLonger = size.width > size.height;

    if (widthIsLonger) {
      return sizeLongerSideOnCanvas / size.width;
    } else {
      return sizeLongerSideOnCanvas / size.height;
    }
  }

  static double getCanvasWidthOfRawImage(
    Uint8List rawImage, {
    required double sizeLongerSideOnCanvas,
  }) {
    final size = sizeOfRawImage(rawImage);

    final widthIsLonger = size.width > size.height;

    if (widthIsLonger) {
      return sizeLongerSideOnCanvas;
    } else {
      return sizeLongerSideOnCanvas * (size.width / size.height);
    }
  }

  static double aspectRatioOfRawImage(Uint8List rawImage) {
    final size = sizeOfRawImage(rawImage);

    return size.width / size.height;
  }

  static Offset getCenteredCoordinatesForPicture(Size size) {
    final currentCanvasSize = CanvasController.canvasSizePixel;
    final scalingFactor = CanvasController.canvasScalingFactor;

    return Offset(
      ((currentCanvasSize.width / scalingFactor) - size.width) / 2,
      ((currentCanvasSize.height / scalingFactor) - size.height) / 2,
    );
  }

  /// Gets the size of a raw image.
  ///
  /// This method handles both bitmap images (PNG, JPEG, etc.) and SVG images:
  /// - For SVG images, it delegates to SvgUtils.getSvgSize
  /// - For bitmap images, it reads the width and height from the image header
  ///
  /// Returns a default size of 100x100 if the image format is not recognized or dimensions can't be determined.
  static Size sizeOfRawImage(Uint8List image) {
    // Check if it's an SVG file
    if (SvgUtils.isSvg(image)) {
      return SvgUtils.getSvgSize(image);
    }

    // Handle PNG and other bitmap formats
    try {
      final byteData = ByteData.sublistView(image);
      final width = byteData.getUint32(16).toDouble();
      final height = byteData.getUint32(20).toDouble();

      // Validate dimensions (avoid unreasonable values)
      if (width > 0 && width < 10000 && height > 0 && height < 10000) {
        return Size(width, height);
      } else {
        return const Size(100, 100); // Default size for invalid dimensions
      }
    } on Exception {
      return const Size(100, 100); // Default size for unrecognized formats
    }
  }

  static Future<RawImageAndName?> rawImageFroMPlatformFile(
    PlatformFile item,
  ) async {
    if (kIsWeb) {
      // Web implementation
      final bytes = item.bytes;
      if (bytes == null) {
        return null;
      }
      return RawImageAndName(image: bytes, name: item.name);
    } else {
      // Desktop/Mobile implementation
      final bytes = await File(item.path!).readAsBytes();

      return RawImageAndName(image: bytes, name: item.name);
    }
  }
}

class RawImageAndName {
  RawImageAndName({
    required this.image,
    required this.name,
  });
  final Uint8List? image;
  final String? name;
}
