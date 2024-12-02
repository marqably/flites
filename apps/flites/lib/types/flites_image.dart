import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../states/open_project.dart';

/// A working file type we use to work with this image
class FlitesImage {
  late Uint8List image;
  late String id;
  String? name;
  Size? originalSize;
  Size? size;
  double scalingFactor = 1;
  EdgeInsets margin = const EdgeInsets.all(0);

  FlitesImage(Uint8List rawImage) {
    initImage(rawImage);

    // generate a random id to identify this image
    id =
        '${DateTime.now().millisecondsSinceEpoch}-${0 + Random().nextInt(14000)}-${0 + Random().nextInt(15000)}';
  }

  /// tries to initialize the image object. If not possible, throws an exception
  void initImage(Uint8List rawImage) {
    // convert image to image object
    // final imageWork = img.decodeImage(rawImage);

    // if (imageWork == null) {
    //   throw Exception('Could not decode image');
    // }

    image = rawImage;

    // originalSize = Size(imageWork.width.toDouble(), imageWork.height.toDouble());
    // size = originalSize;
  }

  /// Allows us to make changes, that will automatically be saved in the global project source file signal
  void saveChanges({
    Size? size,
    double? scalingFactor,
    EdgeInsets? margin,
  }) {
    if (size != null) {
      this.size = size;
    }

    if (margin != null) {
      this.margin = margin;
    }

    if (scalingFactor != null) {
      this.scalingFactor = scalingFactor;
    }

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
