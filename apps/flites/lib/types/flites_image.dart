import 'dart:math';

import 'package:flites/states/canvas_controller.dart';
import 'package:flites/utils/image_processing_utils.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../states/open_project.dart';

/// A working file type we use to work with this image
class FlitesImage {
  late Uint8List image;
  late String id;
  String? displayName;
  String? originalName;

  /// The width of the image on the canvas.
  late double widthOnCanvas;

  /// The scaling factor that was used when importing this image. Stored such
  /// that the user can reset to initial state.
  double? originalScalingFactor;

  double get heightOnCanvas => widthOnCanvas / aspectRatio;
  double get aspectRatio => ImageUtils.aspectRatioOfRawImage(image);
  Offset get center => Offset(positionOnCanvas.dx + widthOnCanvas / 2,
      positionOnCanvas.dy + heightOnCanvas / 2);

  bool get isAtOriginalSize => originalScalingFactor == null
      ? true
      : widthOnCanvas ==
          ImageUtils.sizeOfRawImage(image).width * originalScalingFactor!;

  /// The position of the sprite on the canvas
  late Offset positionOnCanvas;

  double rotation = 0;

  /// Creates a scaled FlitesImage from raw image data.
  ///
  /// This constructor:
  /// 1. Stores the original image data
  /// 2. Calculates the dimensions on canvas based on the scaling factor
  /// 3. Positions the image at the center of the canvas
  /// 4. Generates a unique ID for the image
  ///
  /// Throws an exception if any step fails.
  FlitesImage.scaled(
    Uint8List rawImage, {
    required double scalingFactor,
    this.originalName,
  }) : displayName = originalName {
    try {
      // Store the original image data
      image = rawImage;
      originalScalingFactor = scalingFactor;

      // Get canvas dimensions and scaling factor
      final currentCanvasSize = canvasController.canvasSizePixel;
      final canvasScalingFactor = canvasController.canvasScalingFactor;

      // Calculate image dimensions on canvas
      final imageSize = ImageUtils.sizeOfRawImage(rawImage);
      widthOnCanvas = imageSize.width *
          scalingFactor *
          (currentCanvasSize.width / canvasScalingFactor);

      // Calculate initial position (centered on canvas)
      final initialCoordinates = ImageUtils.getCenteredCoordinatesForPicture(
        Size(widthOnCanvas, heightOnCanvas),
      );
      positionOnCanvas = Offset(initialCoordinates.dx, initialCoordinates.dy);

      // Generate a unique ID for this image
      id =
          '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(14000)}-${Random().nextInt(15000)}';
    } catch (e) {
      // Rethrow with more context
      throw Exception('Failed to create FlitesImage: $e');
    }
  }

  /// Allows us to make changes, that will automatically be saved in the global project source file signal
  void saveChanges({
    Size? size,
    double? scalingFactor,
    EdgeInsets? margin,
  }) {
    final newImage = this;

    // now save the changes in the project source files
    final images = projectSourceFiles.value;

    for (var i = 0; i < images.length; i++) {
      if (images[i].id == id) {
        images[i] = newImage;
        break;
      }
    }
    projectSourceFiles.value = [...images];
  }

  void trimImage() async {
    image = await ImageProcessingUtils.rotateInIsolates(image, rotation);

    rotation = 0;
  }
}
