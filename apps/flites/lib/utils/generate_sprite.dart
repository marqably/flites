// import 'dart:ui';

import 'package:file_saver/file_saver.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

sealed class SpriteConstraints {}

class SpriteHeightConstrained extends SpriteConstraints {
  final double heightPx;

  SpriteHeightConstrained(this.heightPx);
}

class SpriteWidthConstrained extends SpriteConstraints {
  final double widthPx;

  SpriteWidthConstrained(this.widthPx);
}

class SpriteSizeConstrained extends SpriteConstraints {
  final double widthPx;
  final double heightPx;

  SpriteSizeConstrained(this.widthPx, this.heightPx);
}

class ExportSettings {
  final double? marginTopPx;
  final double? marginRightPx;
  final double? marginBottomPx;
  final double? marginLeftPx;

  final SpriteConstraints constraints;

  ExportSettings.heightConstrained({
    this.marginTopPx,
    this.marginRightPx,
    this.marginBottomPx,
    this.marginLeftPx,
    required double heightPx,
  }) : constraints = SpriteHeightConstrained(heightPx);

  ExportSettings.widthConstrained({
    this.marginTopPx,
    this.marginRightPx,
    this.marginBottomPx,
    this.marginLeftPx,
    required double widthPx,
  }) : constraints = SpriteWidthConstrained(widthPx);

  ExportSettings.sizeConstrained({
    this.marginTopPx,
    this.marginRightPx,
    this.marginBottomPx,
    this.marginLeftPx,
    required double widthPx,
    required double heightPx,
  }) : constraints = SpriteSizeConstrained(widthPx, heightPx);

  double get horizontalMargin => (marginLeftPx ?? 0) + (marginRightPx ?? 0);
  double get verticalMargin => (marginTopPx ?? 0) + (marginBottomPx ?? 0);

  SpriteConstraints get maxDimensionsAfterPadding {
    // Needed so that the switch can match the type
    final constraintsV = constraints;

    return switch (constraintsV) {
      // If we have a height constraint, we can calculate the width
      SpriteHeightConstrained() => SpriteHeightConstrained(
          constraintsV.heightPx - (marginTopPx ?? 0) - (marginBottomPx ?? 0),
        ),

      // If we have a width constraint, we can calculate the height
      SpriteWidthConstrained() => SpriteWidthConstrained(
          constraintsV.widthPx - (marginLeftPx ?? 0) - (marginRightPx ?? 0),
        ),

      // If we have both, we can just use them
      SpriteSizeConstrained() => SpriteSizeConstrained(
          constraintsV.widthPx - (marginLeftPx ?? 0) - (marginRightPx ?? 0),
          constraintsV.heightPx - (marginTopPx ?? 0) - (marginBottomPx ?? 0),
        ),
    };
  }
}

// TODO(beau): tests
// If one where to write tests for this application, this would be the place to
// start. Unit tests, testing the singular functions in this file would be have
// the best ROI for all testing inside this application. Ideally testing the if
// the functions work with subclasses of [SpriteConstraints].
class GenerateSprite {
  static exportSprite(ExportSettings settings) async {
    final sourceImages = projectSourceFiles.value;

    final boundingBox = allImagesBoundingBox;

    if (boundingBox == null) {
      return;
    }

    // If we get the end size here, we can reverse engeneer the rest. If both
    // width and height are given, we can just use that. If only one is given,
    // we can calculate the other, by using the max value from the first to the
    // last point of all images along this axis.
    // Then we can size the other side by finding the range along these sides
    // as well.
    final spriteSize = settings.maxDimensionsAfterPadding;

    final images = separateSpriteImages(
      sourceImages,
      boundingBox,
      spriteSize,
      settings,
    );

    if (images.isEmpty) return;

    final width = images.first.width;
    final height = images.first.height;

    final compositeImage = img.Image(
      width: width * images.length,
      height: height,
      numChannels: 4,
      format: img.Format.uint8,
    );

    for (int i = 0; i < images.length; i++) {
      // export images

      img.compositeImage(
        compositeImage,
        images[i],
        dstX: width * i,
      );
    }

    final file = img.encodePng(compositeImage);

    // save the file
    await FileSaver.instance.saveFile(
      name: 'sprite',
      bytes: file,
      ext: 'png',
      mimeType: MimeType.png,
    );
  }

  static List<img.Image> separateSpriteImages(
    List<FlitesImage> fliteImages,
    BoundingBox boundingBox,
    SpriteConstraints constraints,
    ExportSettings settings,
  ) {
    // Calculate origin point for each image using our numbers, then use the
    // scaling factor from there?

    // This factor would be used the easiest if it was just a number between
    // 0 and 1, with 1 being the full size of the image.
    final scalingFactor = switch (constraints) {
      SpriteSizeConstrained() =>
        scalingWithBoundingBox(constraints, boundingBox),
      SpriteHeightConstrained() => scalingFactorForSizeAlongAxis(
          constraints.heightPx, Axis.vertical,
          images: fliteImages),
      SpriteWidthConstrained() => scalingFactorForSizeAlongAxis(
          constraints.widthPx, Axis.horizontal,
          images: fliteImages),
    };

    final List<img.Image> images = [];

    final frameSize = sizeOfFrame(boundingBox.size, settings);

    for (final fliteImage in fliteImages) {
      final decodedImage = img.decodeImage(fliteImage.image);

      if (decodedImage == null) {
        continue;
      }

      // Sprite scaled to correct size
      final scaledImage = img.copyResize(
        decodedImage,
        width: (fliteImage.widthOnCanvas * scalingFactor).toInt(),
        height: (fliteImage.heightOnCanvas * scalingFactor).toInt(),
      );

      // Blank canvas
      final canvas = img.Image(
        width: frameSize.width.toInt(),
        height: frameSize.height.toInt(),
        numChannels: 4,
        format: img.Format.uint8,
      );

      final offset =
          (fliteImage.positionOnCanvas - boundingBox.position) * scalingFactor;

      final frame = img.compositeImage(
        canvas,
        scaledImage,
        dstX: offset.dx.toInt(),
        dstY: offset.dy.toInt(),
      );

      images.add(frame);
    }

    return images;
  }

  static Size sizeOfFrame(
    Size sizeOfBoundingBox,
    ExportSettings settings,
  ) {
    // Aspect ratio of the bounding box
    final aspectRatioOfAllSprites =
        sizeOfBoundingBox.width / sizeOfBoundingBox.height;

    final constraints = settings.maxDimensionsAfterPadding;

    late final Size size;

    if (constraints is SpriteSizeConstrained) {
      /// Then we know that in the settings both height and width were set
      final settingContraints = settings.constraints as SpriteSizeConstrained;

      size = Size(
        settingContraints.widthPx,
        settingContraints.heightPx,
      );
    }

    if (constraints is SpriteWidthConstrained) {
      final settingContraints = settings.constraints as SpriteWidthConstrained;

      size = Size(
        settingContraints.widthPx,
        (settingContraints.widthPx / aspectRatioOfAllSprites) +
            settings.verticalMargin,
      );
    }

    if (constraints is SpriteHeightConstrained) {
      final settingContraints = settings.constraints as SpriteHeightConstrained;

      size = Size(
        (settingContraints.heightPx * aspectRatioOfAllSprites) +
            settings.horizontalMargin,
        settingContraints.heightPx,
      );
    }

    return size;
  }

  static double scalingWithBoundingBox(
    SpriteSizeConstrained maxSpriteSize,
    BoundingBox boundingBox,
  ) {
    final Axis longestAxis = boundingBox.size.width > boundingBox.size.height
        ? Axis.horizontal
        : Axis.vertical;

    if (longestAxis == Axis.horizontal) {
      return scalingFactorForSizeAlongAxis(
        maxSpriteSize.widthPx,
        longestAxis,
        images: projectSourceFiles.value,
      );
    } else {
      return scalingFactorForSizeAlongAxis(
        maxSpriteSize.heightPx,
        longestAxis,
        images: projectSourceFiles.value,
      );
    }
  }

  static double scalingFactorForSizeBestFit(
    Size size, {
    required List<FlitesImage> images,
  }) {
    final longestSide = size.width > size.height ? size.width : size.height;

    return scalingFactorForSizeAlongAxis(
      longestSide,
      Axis.horizontal,
      images: images,
    );
  }

  static double scalingFactorForSizeAlongAxis(
    double length,
    Axis axis, {
    required List<FlitesImage> images,
  }) {
    final firstPoint = images.fold(double.infinity, (value, image) {
      final pos = image.positionOnCanvas;

      // The starting position along the axis
      final firstPoint = axis == Axis.horizontal ? pos.dx : pos.dy;

      // Use the first point along this axis
      return value < firstPoint ? value : firstPoint;
    });

    final lastPoint = images.fold(0.0, (value, image) {
      final pos = image.positionOnCanvas;

      // The ending position along the axis
      final startingPositionOnAxis = axis == Axis.horizontal ? pos.dx : pos.dy;
      final lengthOfImageInDirection =
          axis == Axis.horizontal ? image.widthOnCanvas : image.heightOnCanvas;

      final lastPoint = startingPositionOnAxis + lengthOfImageInDirection;

      // Use the last point along this axis
      return value > lastPoint ? value : lastPoint;
    });

    final range = lastPoint - firstPoint;

    final scalingFactor = length / range;

    return scalingFactor;
  }
}
