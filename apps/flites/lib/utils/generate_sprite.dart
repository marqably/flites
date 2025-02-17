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
          constraintsV.widthPx,
        ),
      // If we have both, we can just use them
      SpriteSizeConstrained() => SpriteSizeConstrained(
          constraintsV.widthPx,
          constraintsV.heightPx - (paddingTopPx ?? 0) - (paddingBottomPx ?? 0),
        ),
    };
  }
}

class GenerateSprite {
  static Future<void> exportSprite(
    ExportSettings settings, {
    FileSaver? fileSaver,
  }) async {
    _validateDimensions(settings.constraints);
    _validatePadding(settings);

    final sourceImages = projectSourceFiles.value;
    final boundingBox = allImagesBoundingBox;

    // Early return if no valid images or bounding box
    if (boundingBox == null || sourceImages.isEmpty) {
      return;
    }

    // Process frames
    final spriteSize = settings.maxDimensionsAfterPadding;
    final frames = separateSpriteImages(
      sourceImages,
      boundingBox,
      spriteSize,
      settings,
    );

    if (frames.isEmpty) return;

    // Calculate dimensions
    final frameSize = sizeOfFrame(boundingBox.size, settings);
    final spriteSheetWidth = _calculateSpriteSheetWidth(
      settings,
      frames.length,
      frameSize.width,
      settings.paddingLeftPx ?? 0,
    );
    final spriteSheetHeight = _calculateSpriteSheetHeight(
      settings,
      frameSize.height,
      settings.paddingTopPx ?? 0,
      settings.paddingBottomPx ?? 0,
    );

    // Create and compose sprite
    final spriteSheet = img.Image(
      width: spriteSheetWidth.toInt(),
      height: spriteSheetHeight.toInt(),
      numChannels: 4,
      format: img.Format.uint8,
    );

    // Position each frame with padding
    for (int i = 0; i < frames.length; i++) {
      final xPos = i * (frameSize.width + settings.horizontalMargin);
      img.compositeImage(
        spriteSheet,
        frames[i],
        dstX: (xPos + (settings.paddingLeftPx ?? 0)).toInt(),
        dstY: (settings.paddingTopPx ?? 0).toInt(),
      );
    }

    // Save the sprite
    await _saveSpriteSheet(
      spriteSheet,
      settings.fileName ?? 'sprite',
      settings.path,
      fileSaver ?? FileSaver.instance,
    );
  }

  static Future<void> _saveSpriteSheet(
    img.Image spriteSheet,
    String fileName,
    String? path,
    FileSaver saver,
  ) async {
    final spriteData = img.encodePng(spriteSheet);
    try {
      if (path != null) {
        await File('$path/$fileName.png').writeAsBytes(spriteData);
      } else {
        await saver.saveFile(
          name: fileName,
          bytes: spriteData,
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
    if (fliteImages.isEmpty) {
      return [];
    }

    final scalingFactor = switch (constraints) {
      SpriteSizeConstrained() =>
        scalingWithBoundingBox(constraints, boundingBox, images: fliteImages),
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
      img.Image? decodedImage;
      try {
        decodedImage = img.decodeImage(fliteImage.image);
      } catch (e) {
        debugPrint('Failed to decode image: $e');
        continue;
      }

      if (decodedImage == null) {
        continue;
      }

      // Scale image to fit frame
      final scaledWidth = (fliteImage.widthOnCanvas * scalingFactor).toInt();
      final scaledHeight = (fliteImage.heightOnCanvas * scalingFactor).toInt();
      final scaledImage = img.copyResize(
        decodedImage,
        width: scaledWidth,
        height: scaledHeight,
      );

      // Create frame with exact dimensions
      final frame = img.Image(
        width: frameSize.width.toInt(),
        height: frameSize.height.toInt(),
        numChannels: 4,
        format: img.Format.uint8,
      );

      // Calculate position to center the image in the frame
      final offset =
          (fliteImage.positionOnCanvas - boundingBox.position) * scalingFactor;
      img.compositeImage(
        frame,
        scaledImage,
        dstX: offset.dx.toInt(),
        dstY: offset.dy.toInt(),
      );

      images.add(frame);
    }

    return images;
  }

  static Size sizeOfFrame(Size boundingBoxSize, ExportSettings settings) {
    final aspectRatioOfAllSprites =
        boundingBoxSize.width / boundingBoxSize.height;
    final constraints = settings.constraints;

    return switch (constraints) {
      SpriteHeightConstrained() => Size(
          (constraints.heightPx - settings.verticalMargin) *
              aspectRatioOfAllSprites,
          constraints.heightPx,
        ),
      SpriteWidthConstrained() => Size(
          constraints.widthPx,
          constraints.widthPx / aspectRatioOfAllSprites,
        ),
      SpriteSizeConstrained() => Size(
          constraints.widthPx,
          constraints.heightPx,
        ),
    };
  }

  static double scalingWithBoundingBox(
    SpriteSizeConstrained maxSpriteSize,
    BoundingBox boundingBox, {
    required List<FlitesImage> images,
  }) {
    final Axis longestAxis = boundingBox.size.width > boundingBox.size.height
        ? Axis.horizontal
        : Axis.vertical;

    if (longestAxis == Axis.horizontal) {
      return scalingFactorForSizeAlongAxis(
        maxSpriteSize.widthPx,
        longestAxis,
        images: images,
      );
    } else {
      return scalingFactorForSizeAlongAxis(
        maxSpriteSize.heightPx,
        longestAxis,
        images: images,
      );
    }
  }

  static double scalingFactorForSizeBestFit(
    Size size, {
    required List<FlitesImage> images,
  }) {
    final longestSide = size.width > size.height ? size.width : size.height;
    final axis = size.width > size.height ? Axis.horizontal : Axis.vertical;
    return scalingFactorForSizeAlongAxis(
      longestSide,
      axis,
      images: images,
    );
  }

  static double scalingFactorForSizeAlongAxis(
    double length,
    Axis axis, {
    required List<FlitesImage> images,
  }) {
    if (images.isEmpty) {
      throw Exception('Cannot calculate scaling factor for empty image list');
    }

    // Check for zero width/height
    final hasZeroDimension = images.any((image) {
      final dimension =
          axis == Axis.horizontal ? image.widthOnCanvas : image.heightOnCanvas;
      return dimension <= 0;
    });
    if (hasZeroDimension) {
      throw Exception(
          'Cannot calculate scaling factor when images have zero or negative dimensions');
    }

    // Find the minimum and maximum points along the axis
    double minPoint = double.infinity;
    double maxPoint = double.negativeInfinity;

    for (final image in images) {
      final pos = image.positionOnCanvas;
      final startPoint = axis == Axis.horizontal ? pos.dx : pos.dy;
      final imageLength =
          axis == Axis.horizontal ? image.widthOnCanvas : image.heightOnCanvas;
      final endPoint = startPoint + imageLength;

      minPoint = minPoint < startPoint ? minPoint : startPoint;
      maxPoint = maxPoint > endPoint ? maxPoint : endPoint;
    }

    final totalRange = maxPoint - minPoint;
    return length / totalRange;
  }

  static void _validateDimensions(SpriteConstraints constraints) {
    switch (constraints) {
      case SpriteSizeConstrained():
        if (constraints.widthPx <= 0 || constraints.heightPx <= 0) {
          throw Exception('Width and height must be positive values');
        }
      case SpriteWidthConstrained():
        if (constraints.widthPx <= 0) {
          throw Exception('Width must be a positive value');
        }
      case SpriteHeightConstrained():
        if (constraints.heightPx <= 0) {
          throw Exception('Height must be a positive value');
        }
    }
  }

  static void _validatePadding(ExportSettings settings) {
    if ((settings.paddingLeftPx ?? 0) < 0 ||
        (settings.paddingRightPx ?? 0) < 0 ||
        (settings.paddingTopPx ?? 0) < 0 ||
        (settings.paddingBottomPx ?? 0) < 0) {
      throw Exception('Padding values must be non-negative');
    }
  }

  static double _calculateSpriteSheetWidth(ExportSettings settings,
      int frameCount, double frameWidth, double leftPadding) {
    // Each frame gets its own padding
    final paddingPerFrame =
        (settings.paddingLeftPx ?? 0) + (settings.paddingRightPx ?? 0);
    return frameWidth * frameCount + (paddingPerFrame * frameCount);
  }

  static double _calculateSpriteSheetHeight(ExportSettings settings,
      double frameHeight, double topPadding, double bottomPadding) {
    switch (settings.constraints.runtimeType) {
      case SpriteSizeConstrained:
        return (settings.constraints as SpriteSizeConstrained).heightPx;
      default:
        return frameHeight + topPadding + bottomPadding;
    }
  }
}
