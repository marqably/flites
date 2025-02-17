// import 'dart:ui';

import 'dart:io';

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
  final double? paddingTopPx;
  final double? paddingRightPx;
  final double? paddingBottomPx;
  final double? paddingLeftPx;
  final String? fileName;
  final String? path;

  final SpriteConstraints constraints;

  ExportSettings.heightConstrained({
    this.paddingTopPx,
    this.paddingRightPx,
    this.paddingBottomPx,
    this.paddingLeftPx,
    this.fileName,
    this.path,
    required double heightPx,
  }) : constraints = SpriteHeightConstrained(heightPx);

  ExportSettings.widthConstrained({
    this.paddingTopPx,
    this.paddingRightPx,
    this.paddingBottomPx,
    this.paddingLeftPx,
    this.fileName,
    this.path,
    required double widthPx,
  }) : constraints = SpriteWidthConstrained(widthPx);

  ExportSettings.sizeConstrained({
    this.paddingTopPx,
    this.paddingRightPx,
    this.paddingBottomPx,
    this.paddingLeftPx,
    this.fileName,
    this.path,
    required double widthPx,
    required double heightPx,
  }) : constraints = SpriteSizeConstrained(widthPx, heightPx);

  double get horizontalMargin => (paddingLeftPx ?? 0) + (paddingRightPx ?? 0);
  double get verticalMargin => (paddingTopPx ?? 0) + (paddingBottomPx ?? 0);

  SpriteConstraints get maxDimensionsAfterPadding {
    // Needed so that the switch can match the type
    final constraintsV = constraints;

    return switch (constraintsV) {
      // If we have a height constraint, we can calculate the width
      SpriteHeightConstrained() => SpriteHeightConstrained(
          constraintsV.heightPx - (paddingTopPx ?? 0) - (paddingBottomPx ?? 0),
        ),

      // If we have a width constraint, we can calculate the height
      SpriteWidthConstrained() => SpriteWidthConstrained(
          constraintsV.widthPx - (paddingLeftPx ?? 0) - (paddingRightPx ?? 0),
        ),

      // If we have both, we can just use them
      SpriteSizeConstrained() => SpriteSizeConstrained(
          constraintsV.widthPx - (paddingLeftPx ?? 0) - (paddingRightPx ?? 0),
          constraintsV.heightPx - (paddingTopPx ?? 0) - (paddingBottomPx ?? 0),
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

    // If we get the end size here, we can reverse engineer the rest. If both
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

    final double leftPadding = settings.paddingLeftPx ?? 0;
    final double rightPadding = settings.paddingRightPx ?? 0;
    final double topPadding = settings.paddingTopPx ?? 0;
    final double bottomPadding = settings.paddingBottomPx ?? 0;

    // Calculate the total width and height including padding
    final double totalWidth =
        (width * images.length) + leftPadding + rightPadding;
    final double totalHeight = height + topPadding + bottomPadding;

    // Create the composite image with the total dimensions
    final compositeImage = img.Image(
      width: totalWidth.toInt(),
      height: totalHeight.toInt(),
      numChannels: 4,
      format: img.Format.uint8,
    );

    // Check the number of images
    if (images.length == 1) {
      // Handle the case for a single image
      img.compositeImage(
        compositeImage,
        images[0],
        dstX: ((compositeImage.width - width) / 2).toInt(),
        dstY: ((compositeImage.height - height) / 2).toInt(),
      );
    } else {
      // Loop through each image for multiple images
      for (int i = 0; i < images.length; i++) {
        img.compositeImage(
          compositeImage,
          images[i],
          dstX: (width * i) + leftPadding.toInt(), // Adjust for left padding
          dstY: topPadding.toInt(), // Adjust for top padding
        );
      }
    }

    final file = img.encodePng(compositeImage);
    final fileName = settings.fileName ?? 'sprite';

    try {
      if (settings.path != null) {
        // Direct file write to selected path
        final savePath = '${settings.path}/$fileName.png';
        await File(savePath).writeAsBytes(file);
      } else {
        // Use FileSaver for default Downloads location
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: file,
          ext: 'png',
          mimeType: MimeType.png,
        );
      }
    } catch (e) {
      debugPrint('Error saving file: $e');
      rethrow;
    }
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
      final settingConstraints = settings.constraints as SpriteSizeConstrained;

      size = Size(
        settingConstraints.widthPx,
        settingConstraints.heightPx,
      );
    }

    if (constraints is SpriteWidthConstrained) {
      final settingConstraints = settings.constraints as SpriteWidthConstrained;

      size = Size(
        settingConstraints.widthPx,
        (settingConstraints.widthPx / aspectRatioOfAllSprites) +
            settings.verticalMargin,
      );
    }

    if (constraints is SpriteHeightConstrained) {
      final settingConstraints =
          settings.constraints as SpriteHeightConstrained;

      size = Size(
        (settingConstraints.heightPx * aspectRatioOfAllSprites) +
            settings.horizontalMargin,
        settingConstraints.heightPx,
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
