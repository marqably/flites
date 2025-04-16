import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flites/services/file_service.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/types/export_settings.dart';
import 'package:flites/types/sprite_constraints.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/material.dart';

/// Handles the generation of SVG sprite sheets from multiple SVG images.
class GenerateSvgSprite {
  static Future<void> exportSpriteMap({
    FileService? fileService,
  }) async {
    final sourceFiles = projectSourceFiles.value;

    final spriteRowImages = <Uint8List>[];

    for (int i = 0; i < sourceFiles.rows.length; i++) {
      final spriteRowImage = await createSpriteRowImage(
        sourceFiles.rows[i].exportSettings,
        spriteRowIndex: i,
      );

      if (spriteRowImage != null) {
        spriteRowImages.add(spriteRowImage);
      }
    }

    // Find longest width
    int longestWidth = 0;

    // Find total height of all rows
    int totalHeight = 0;

    for (int i = 0; i < spriteRowImages.length; i++) {
      final boundingBox = boundingBoxOfRow(i);

      if (boundingBox == null) {
        throw Exception('Bounding box is null');
      }

      ExportSettings settings = sourceFiles.rows[i].exportSettings;

      /// Override settings if no height & width provided
      if ((settings.widthPx == null || settings.widthPx == 0) &&
          (settings.heightPx == null || settings.heightPx == 0)) {
        settings = settings.copyWith(
          widthPx: boundingBox.size.width.toInt(),
          heightPx: boundingBox.size.height.toInt(),
        );
      }

      // Calculate dimensions
      final frameSize = GenerateSprite.sizeOfFrame(
        boundingBox.size,
        settings,
      );

      final imagesInRow = sourceFiles.rows[i].images.length;

      longestWidth = max(
        longestWidth,
        (frameSize.width.toInt() * imagesInRow),
      );
      totalHeight += frameSize.height.toInt();
    }

    // Build the SVG buffer for the whole sprite map
    final svgBuffer = StringBuffer();

    // SVG header with calculated dimensions
    svgBuffer.write('''
<svg xmlns="http://www.w3.org/2000/svg" width="$longestWidth" height="$totalHeight" viewBox="0 0 $longestWidth $totalHeight">
''');

    int offsetY = 0;

    // Position each row in the sprite sheet
    // Add each SVG image as a grouped element with appropriate translation
    for (int i = 0; i < spriteRowImages.length; i++) {
      final rowImage = spriteRowImages[i];

      // Skip non-SVG images
      if (!SvgUtils.isSvg(rowImage)) continue;

      // Calculate position for this frame's origin
      final frameYPos = offsetY;

      // Extract the original SVG content
      final svgString = String.fromCharCodes(rowImage);

      final contentMatch =
          RegExp(r'<svg[^>]*>([\s\S]*)<\/svg>').firstMatch(svgString);

      final svgContent = contentMatch?.group(1) ?? '';

      svgBuffer.write('''
  <g transform="translate(0, ${frameYPos.toStringAsFixed(2)})">
      $svgContent
  </g>
''');

      final boundingBox = boundingBoxOfRow(i);

      if (boundingBox == null) {
        throw Exception('Bounding box is null');
      }

      ExportSettings settings = sourceFiles.rows[i].exportSettings;

      /// Override settings if no height & width provided
      if ((settings.widthPx == null || settings.widthPx == 0) &&
          (settings.heightPx == null || settings.heightPx == 0)) {
        settings = settings.copyWith(
          widthPx: boundingBox.size.width.toInt(),
          heightPx: boundingBox.size.height.toInt(),
        );
      }

      // Calculate dimensions
      final frameSize = GenerateSprite.sizeOfFrame(
        boundingBox.size,
        settings,
      );

      offsetY += frameSize.height.toInt();
    }

    // Close SVG
    svgBuffer.write('</svg>');

    // Save the SVG sprite
    final svgData = Uint8List.fromList(utf8.encode(svgBuffer.toString()));

    _saveSpriteSheet(
      svgData,
      fileService ?? const FileService(),
    );
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

  /// Exports a collection of SVG images as a single SVG sprite sheet.
  ///
  /// This creates a combined SVG that includes all individual SVG images
  /// in a horizontal sprite sheet format while maintaining the vector format
  /// for high-quality scaling.
  static Future<Uint8List?> createSpriteRowImage(
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

    _validateInput(settings);

    // Calculate dimensions
    final frameSize = GenerateSprite.sizeOfFrame(boundingBox.size, settings);

    final spriteSheetWidth = _calculateSpriteSheetWidth(
      settings,
      images.length,
      frameSize.width,
      settings.paddingLeftPx.toDouble(),
    );
    final spriteSheetHeight = _calculateSpriteSheetHeight(
      settings,
      frameSize.height,
      settings.paddingTopPx.toDouble(),
      settings.paddingBottomPx.toDouble(),
    );

    // Calculate scaling factor for images
    final scalingFactor = switch (settings.constraints) {
      SpriteSizeConstrained() => GenerateSprite.scalingWithBoundingBox(
          settings.constraints as SpriteSizeConstrained,
          boundingBox,
          images: images,
        ),
      SpriteHeightConstrained() => GenerateSprite.scalingFactorForSizeAlongAxis(
          (settings.constraints as SpriteHeightConstrained).heightPx.toDouble(),
          Axis.vertical,
          images: images,
        ),
      SpriteWidthConstrained() => GenerateSprite.scalingFactorForSizeAlongAxis(
          (settings.constraints as SpriteWidthConstrained).widthPx.toDouble(),
          Axis.horizontal,
          images: images,
        ),
    };

    // Build the SVG sprite sheet
    final svgBuffer = StringBuffer();

    // SVG header with calculated dimensions
    svgBuffer.write('''
<svg xmlns="http://www.w3.org/2000/svg" width="${spriteSheetWidth.toInt()}" height="${spriteSheetHeight.toInt()}" viewBox="0 0 ${spriteSheetWidth.toInt()} ${spriteSheetHeight.toInt()}">
''');

    // Add each SVG image as a grouped element with appropriate translation
    for (int i = 0; i < images.length; i++) {
      final fliteImage = images[i];

      // Skip non-SVG images
      if (!SvgUtils.isSvg(fliteImage.image)) continue;

      // Calculate position for this frame's origin
      final frameXPos = i * (frameSize.width + settings.horizontalMargin);
      final frameYPos = settings.paddingTopPx;

      // Extract the original SVG content
      final svgString = String.fromCharCodes(fliteImage.image);
      final contentMatch =
          RegExp(r'<svg[^>]*>([\s\S]*)<\/svg>').firstMatch(svgString);
      final svgContent = contentMatch?.group(1) ?? '';

      // Calculate the image's position within the bounding box, scaled to the output dimensions
      final relativeOffset =
          (fliteImage.positionOnCanvas - boundingBox.position) * scalingFactor;

      // Get original SVG dimensions
      final originalSize = SvgUtils.getSvgSize(fliteImage.image);

      // Calculate scale transform needed for the SVG
      final imageScale =
          (fliteImage.widthOnCanvas / originalSize.width) * scalingFactor;

      // Add to sprite sheet with appropriate transformation:
      // 1. Translate to the frame position
      // 2. Translate to the relative position within the frame
      // 3. Scale the SVG content appropriately
      svgBuffer.write('''
  <g transform="translate(${(frameXPos + settings.paddingLeftPx).toStringAsFixed(2)}, ${frameYPos.toStringAsFixed(2)})">
    <g transform="translate(${relativeOffset.dx.toStringAsFixed(2)}, ${relativeOffset.dy.toStringAsFixed(2)}) scale(${imageScale.toStringAsFixed(6)})">
      $svgContent
    </g>
  </g>
''');
    }

    // Close SVG
    svgBuffer.write('</svg>');

    // Save the SVG sprite
    final svgData = Uint8List.fromList(utf8.encode(svgBuffer.toString()));

    return svgData;
  }

  static Future<void> _saveSpriteSheet(
    Uint8List svgData,
    FileService fileService,
  ) async {
    try {
      await fileService.saveFile(
        bytes: svgData,
        fileType: FileType.image,
        fileExtension: 'svg',
      );
    } catch (e) {
      debugPrint('Error saving file: $e');
      rethrow;
    }
  }

  /// Validates input parameters for sprite generation.
  static void _validateInput(ExportSettings settings) {
    // Validate dimensions
    switch (settings.constraints) {
      case SpriteSizeConstrained():
        if ((settings.constraints as SpriteSizeConstrained).widthPx <= 0 ||
            (settings.constraints as SpriteSizeConstrained).heightPx <= 0) {
          throw Exception('Width and height must be positive values');
        }
      case SpriteWidthConstrained():
        if ((settings.constraints as SpriteWidthConstrained).widthPx <= 0) {
          throw Exception('Width must be a positive value');
        }
      case SpriteHeightConstrained():
        if ((settings.constraints as SpriteHeightConstrained).heightPx <= 0) {
          throw Exception('Height must be a positive value');
        }
    }

    // Validate padding
    if (settings.paddingLeftPx < 0 ||
        settings.paddingRightPx < 0 ||
        settings.paddingTopPx < 0 ||
        settings.paddingBottomPx < 0) {
      throw Exception('Padding values must be non-negative');
    }
  }

  /// Calculates the width of the sprite sheet based on frame width, count, and padding.
  static double _calculateSpriteSheetWidth(
    ExportSettings settings,
    int frameCount,
    double frameWidth,
    double leftPadding,
  ) {
    // Each frame gets its own padding
    final paddingPerFrame = settings.horizontalMargin;
    return frameWidth * frameCount + (paddingPerFrame * frameCount);
  }

  /// Calculates the height of the sprite sheet based on frame height and padding.
  static double _calculateSpriteSheetHeight(
    ExportSettings settings,
    double frameHeight,
    double topPadding,
    double bottomPadding,
  ) {
    switch (settings.constraints.runtimeType) {
      case SpriteSizeConstrained _:
        return (settings.constraints as SpriteSizeConstrained)
            .heightPx
            .toDouble();
      default:
        return frameHeight + topPadding + bottomPadding;
    }
  }
}
