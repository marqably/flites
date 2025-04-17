import 'package:file_picker/file_picker.dart';
import 'package:flites/services/file_service.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/types/export_settings.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/types/sprite_constraints.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class GenerateSprite {
  static Future<img.Image?> exportTiledSpriteMap({
    required Size tileSize,
  }) async {
    return exportSpriteMap(tileSize: tileSize);
  }

  static Future<img.Image?> exportSpriteMap({
    FileService? fileService,
    Size? tileSize,
  }) async {
    final sourceFiles = projectSourceFiles.value;

    final spriteRowImages = <img.Image>[];

    for (int i = 0; i < sourceFiles.rows.length; i++) {
      // If [tileSize] is provided, override the export settings of each row
      // to use a size constrained setting with the tile size as height and
      // width.
      final spriteRowImage = await createSpriteRowImage(
        sourceFiles.rows[i].exportSettings.copyWith(
          heightPx: tileSize?.height.toInt(),
          widthPx: tileSize?.width.toInt(),
        ),
        spriteRowIndex: i,
      );

      if (spriteRowImage != null) {
        spriteRowImages.add(spriteRowImage);
      }
    }

    // Find longest width
    final longestWidth = spriteRowImages.map((e) => e.width).reduce(
          (a, b) => a > b ? a : b,
        );

    // Find total height of all rows
    final totalHeight = spriteRowImages.map((e) => e.height).reduce(
          (a, b) => a + b,
        );

    // Create composite sprite sheet of a vertical list with all rows
    final spriteSheet = img.Image(
      width: longestWidth.toInt(),
      height: totalHeight.toInt(),
      numChannels: 4,
      format: img.Format.uint8,
    );

    int offsetY = 0;
    // Position each row in the sprite sheet
    for (int i = 0; i < spriteRowImages.length; i++) {
      img.compositeImage(
        spriteSheet,
        spriteRowImages[i],
        dstX: 0,
        dstY: offsetY,
      );

      offsetY += spriteRowImages[i].height;
    }

    _saveSpriteSheet(
      spriteSheet,
      fileService ?? const FileService(),
    );

    return spriteSheet;
  }

  static Future<void> exportSpriteRow(
    ExportSettings settings, {
    required int spriteRowIndex,
    FileService? fileService,
  }) async {
    final spriteRowImage = await createSpriteRowImage(
      settings,
      spriteRowIndex: spriteRowIndex,
    );

    if (spriteRowImage == null) {
      return;
    }

    // Save the sprite
    await _saveSpriteSheet(
      spriteRowImage,
      fileService ?? const FileService(),
    );
  }

  static Future<img.Image?> createSpriteRowImage(
    ExportSettings settings, {
    required int spriteRowIndex,
  }) async {
    final images = projectSourceFiles.value.rows[spriteRowIndex].images;

    final boundingBox = boundingBoxOfRow(spriteRowIndex);

    // Early return if no valid images or bounding box
    if (boundingBox == null || images.isEmpty) {
      return null;
    }

    /// Override settings if no height & width provided
    if ((settings.widthPx == null || settings.widthPx == 0) &&
        (settings.heightPx == null || settings.heightPx == 0)) {
      settings = settings.copyWith(
        widthPx: boundingBox.size.width.toInt(),
        heightPx: boundingBox.size.height.toInt(),
      );
    }

    _validateDimensions(settings.constraints);
    _validatePadding(settings);

    // Process frames
    final spriteSize = settings.maxDimensionsAfterPadding;

    final frames = separateSpriteImages(
      images,
      boundingBox,
      spriteSize,
      settings,
    );

    if (frames.isEmpty) return null;

    // Calculate dimensions
    final frameSize = sizeOfFrame(boundingBox.size, settings);

    final spriteSheetWidth = _calculateSpriteSheetWidth(
      settings,
      frames.length,
      frameSize.width,
      settings.paddingLeftPx.toDouble(),
    );

    final spriteSheetHeight = _calculateSpriteSheetHeight(
      settings,
      frameSize.height,
      settings.paddingTopPx.toDouble(),
      settings.paddingBottomPx.toDouble(),
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
      final dstX = (xPos + settings.paddingLeftPx).toInt();
      final dstY = settings.paddingTopPx.toInt();

      // Composite the actual frame image
      img.compositeImage(
        spriteSheet,
        frames[i],
        dstX: dstX,
        dstY: dstY,
      );
    }

    return spriteSheet;
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
          constraints.heightPx.toDouble(),
          Axis.vertical,
          images: fliteImages,
        ),
      SpriteWidthConstrained() => scalingFactorForSizeAlongAxis(
          constraints.widthPx.toDouble(),
          Axis.horizontal,
          images: fliteImages,
        ),
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
          constraints.heightPx.toDouble(),
        ),
      SpriteWidthConstrained() => Size(
          constraints.widthPx.toDouble(),
          constraints.widthPx / aspectRatioOfAllSprites,
        ),
      SpriteSizeConstrained() => Size(
          constraints.widthPx.toDouble(),
          constraints.heightPx.toDouble(),
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
        maxSpriteSize.widthPx.toDouble(),
        longestAxis,
        images: images,
      );
    } else {
      return scalingFactorForSizeAlongAxis(
        maxSpriteSize.heightPx.toDouble(),
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

    /// TODO: this gives a negative scaling factor for Axis.vertical

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

  static Future<void> _saveSpriteSheet(
    img.Image spriteSheet,
    FileService fileService,
  ) async {
    final spriteData = img.encodePng(spriteSheet);
    try {
      await fileService.saveFile(
        bytes: spriteData,
        fileType: FileType.custom,
        fileExtension: 'png',
      );
    } catch (e) {
      debugPrint('Error saving file: $e');
      rethrow;
    }
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
    if (settings.paddingLeftPx < 0 ||
        settings.paddingRightPx < 0 ||
        settings.paddingTopPx < 0 ||
        settings.paddingBottomPx < 0) {
      throw Exception('Padding values must be non-negative');
    }
  }

  static double _calculateSpriteSheetWidth(ExportSettings settings,
      int frameCount, double frameWidth, double leftPadding) {
    // Each frame gets its own padding
    final paddingPerFrame = settings.horizontalMargin;

    return frameWidth * frameCount + (paddingPerFrame * frameCount);
  }

  static double _calculateSpriteSheetHeight(
    ExportSettings settings,
    double frameHeight,
    double topPadding,
    double bottomPadding,
  ) {
    switch (settings.constraints.runtimeType) {
      // ignore: type_literal_in_constant_pattern
      case SpriteSizeConstrained:
        return (settings.constraints as SpriteSizeConstrained).heightPx +
            topPadding +
            bottomPadding;
      default:
        return frameHeight + topPadding + bottomPadding;
    }
  }
}
