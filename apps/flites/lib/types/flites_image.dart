import 'dart:math';
import 'dart:typed_data';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/material.dart';

import '../states/open_project.dart';

/// The size a picture should have along its longer side when displayed on the
/// canvas
const defaultSizeOnCanvas = 0.5;

/// A working file type we use to work with this image
class FlitesImage {
  late Uint8List image;
  late String id;
  String? name;

  // The original size of the image
  @Deprecated('Should not be needed in future')
  Size? originalSize;

  // The size of the image that is displayed in the canvas
  // Size? size;

  // // A scaling factor that is determined upon importing to make the image fit
  // // inside the canvas
  // double originalScalingFactor = 1;

  // The scaling factor that is used to change the size of the image inside the
  // canvas
  // double scalingFactor = 1;

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

  // EdgeInsets margin = const EdgeInsets.all(0);

  // FlitesImage(
  //   Uint8List rawImage, {
  //   this.name,
  // }) {
  //   image = rawImage;

  //   widthOnCanvas = ImageUtils.getCanvasWidthOfRawImage(
  //     rawImage,
  //     sizeLongerSideOnCanvas: defaultSizeOnCanvas,
  //   );

  //   final initialCoordinates = ImageUtils.getCenteredCoordinatesForPicture(
  //     Size(widthOnCanvas, heightOnCanvas),
  //   );

  //   positionOnCanvas = Offset(initialCoordinates.dx, initialCoordinates.dy);

  //   // generate a random id to identify this image
  //   id =
  //       '${DateTime.now().millisecondsSinceEpoch}-${0 + Random().nextInt(14000)}-${0 + Random().nextInt(15000)}';
  // }

  FlitesImage.scaled(
    Uint8List rawImage, {
    required double scalingFactor,
    this.name,
  }) {
    image = rawImage;

    originalScalingFactor = scalingFactor;

    final currentCanvasSize = canvasSizePixelSignal.value;
    final canvasScalingFactor = canvasScalingFactorSignal.value;

    widthOnCanvas = ImageUtils.sizeOfRawImage(rawImage).width *
        scalingFactor *
        (currentCanvasSize.width / canvasScalingFactor);

    final initialCoordinates = ImageUtils.getCenteredCoordinatesForPicture(
      Size(widthOnCanvas, heightOnCanvas),
    );

    print('initialCoordinates: $initialCoordinates');

    positionOnCanvas = Offset(initialCoordinates.dx, initialCoordinates.dy);

    // generate a random id to identify this image
    id =
        '${DateTime.now().millisecondsSinceEpoch}-${0 + Random().nextInt(14000)}-${0 + Random().nextInt(15000)}';
  }

  // void resetScaling() {
  //   if (originalScalingFactor == null) return;

  //   widthOnCanvas =
  //       ImageUtils.sizeOfRawImage(image).width * originalScalingFactor!;

  //   saveChanges();
  // }

  // /// tries to initialize the image object. If not possible, throws an exception
  // void initImage(Uint8List rawImage) {
  //   // convert image to image object
  //   // final imageWork = img.decodeImage(rawImage);

  //   // if (imageWork == null) {
  //   //   throw Exception('Could not decode image');
  //   // }

  //   // final size = getSizeOfPng(image.buffer.asByteData());

  //   // originalSize = size;
  //   // originalScalingFactor = size.width / (outputSettings.value.itemWidth ?? 1);

  //   // print('originalScalingFactor: $originalScalingFactor');
  //   // print('originalSize: $originalSize');

  //   // originalSize = Size(imageWork.width.toDouble(), imageWork.height.toDouble());
  //   // size = originalSize;
  // }

  /// Allows us to make changes, that will automatically be saved in the global project source file signal
  void saveChanges({
    Size? size,
    double? scalingFactor,
    EdgeInsets? margin,
  }) {
    // if (size != null) {
    //   this.size = size;
    // }

    // if (margin != null) {
    //   this.margin = margin;
    // }

    // if (scalingFactor != null) {
    //   this.scalingFactor = scalingFactor;
    // }

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
}
