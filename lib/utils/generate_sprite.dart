import 'dart:ui';

import 'package:file_saver/file_saver.dart';
import 'package:flites/types/flites_image.dart';

import '../states/open_project.dart';
import 'package:image/image.dart' as img;

class GenerateSprite {
  /// contains all source images, we want to use within this sprite
  List<FlitesImage> images = [];

  /// contains all source images, we want to use within this sprite
  Map<String, img.Image?> decodedImages = {};

  GenerateSprite(List<FlitesImage> imageList) {
    // decode all images
    for (int indx = 0; indx < imageList.length; indx++) {
      final fliteImage = imageList[indx];
      final decImage = img.decodeImage(fliteImage.image);

      // if we cannot decode -> skip
      if (decImage == null) {
        // TODO: maybe add error message
        continue;
      }

      // save the image size
      fliteImage.originalSize = Size(
        decImage.width.toDouble(),
        decImage.height.toDouble(),
      );

      // add image to list
      decodedImages[fliteImage.id] = decImage;
      images.add(fliteImage);
    }
  }

  /// Takes all the source images and creates a sprite image from them
  void save() async {
    // calculate all image sizes upfront
    images = images.map((e) {
      final size = getItemSize(e);
      e.size = size;

      return e;
    }).toList();

    // now get the biggest size
    final imageItemSize = getLargestSizeConstraint();

    // create a new image with the size of all images combined
    final newImage = img.Image(
      width: (imageItemSize.width * images.length).toInt(),
      height: imageItemSize.height.toInt(),
    );

    // Add all images to the new sprite
    for (int indx = 0; indx < images.length; indx++) {
      final imageObj = images[indx];
      final imageOffset = (imageItemSize.width * indx);

      final decodedImage = decodedImages[imageObj.id];

      // add the image to the new image
      img.compositeImage(
        newImage,
        decodedImage!,
        dstX: imageOffset.toInt(),
        dstY: 0,
      );
    }

    // encode it to png
    final file = img.encodePng(newImage);

    // save the file
    await FileSaver.instance.saveFile(
      name: 'sprite.png',
      bytes: file,
      ext: 'png',
      mimeType: MimeType.png,
    );
  }

  /// Gets the ideal size for this sprite image item
  ///
  /// If we have a width and height, we use that
  /// If we have only one of them, we calculate the other
  /// If we have none, we use the biggest image size
  Size? getItemSize(FlitesImage image) {
    final settings = outputSettings.value;
    final scale = image.scalingFactor;
    final originalSize = image.originalSize!;

    // if we got both width and height, we have the perfect size
    if (settings.itemWidth != null || settings.itemHeight != null) {
      return Size(
        settings.itemWidth!.toDouble(),
        settings.itemHeight!.toDouble(),
      );
    }

    // if we got only one of them, we need to calculate the other
    if (settings.itemWidth != null &&
        (originalSize.width * scale) > settings.itemWidth!) {
      final newHeight =
          (originalSize.width / originalSize.height) * settings.itemHeight!;
      return Size(settings.itemWidth!.toDouble(), newHeight);
    }

    if (settings.itemHeight != null &&
        (originalSize.height * scale) > settings.itemHeight!) {
      final newWidth =
          (originalSize.height / originalSize.width) * settings.itemWidth!;
      return Size(newWidth, settings.itemHeight!.toDouble());
    }

    return Size(
      originalSize.width * scale,
      originalSize.height * scale,
    );
  }

  /// Get the largest size for the sprite image items we need to generate the sprite
  Size getLargestSizeConstraint() {
    // otherwise, loop through all images and find the biggest width and height needed to fit all images
    double biggestWidth = 0;
    double biggestHeight = 0;

    for (final image in images) {
      if (biggestWidth < image.size!.width) {
        biggestWidth = image.size!.width;
      }

      if (biggestHeight < image.size!.height) {
        biggestHeight = image.size!.height;
      }
    }

    return Size(biggestWidth, biggestHeight);
  }
}
