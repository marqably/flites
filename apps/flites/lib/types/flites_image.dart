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

  FlitesImage.scaled(
    Uint8List rawImage, {
    required double scalingFactor,
    this.originalName,
  }) : displayName = originalName {
    image = rawImage;

    originalScalingFactor = scalingFactor;

    final currentCanvasSize = canvasController.canvasSizePixel;
    final canvasScalingFactor = canvasController.canvasScalingFactor;

    widthOnCanvas = ImageUtils.sizeOfRawImage(rawImage).width *
        scalingFactor *
        (currentCanvasSize.width / canvasScalingFactor);

    final initialCoordinates = ImageUtils.getCenteredCoordinatesForPicture(
      Size(widthOnCanvas, heightOnCanvas),
    );

    positionOnCanvas = Offset(initialCoordinates.dx, initialCoordinates.dy);

    // generate a random id to identify this image
    id =
        '${DateTime.now().millisecondsSinceEpoch}-${0 + Random().nextInt(14000)}-${0 + Random().nextInt(15000)}';
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
