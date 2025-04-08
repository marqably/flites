import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/material.dart';

/// Handles the generation of SVG sprite sheets from multiple SVG images.
class GenerateSvgSprite {
  static Future<void> exportSpriteMap(
    ExportSettings settings, {
    FileSaver? fileSaver,
  }) async {
    // TODO(jaco): implement
  }

  /// Exports a collection of SVG images as a single SVG sprite sheet.
  ///
  /// This creates a combined SVG that includes all individual SVG images
  /// in a horizontal sprite sheet format while maintaining the vector format
  /// for high-quality scaling.
  static Future<void> exportSpriteRow(
    ExportSettings settings, {
    required int spriteRowIndex,
    FileSaver? fileSaver,
  }) async {
    _validateInput(settings);

    final images = projectSourceFiles.value.rows[spriteRowIndex].images;
    final boundingBox = allImagesBoundingBox;

    // Early return if no valid images or bounding box
    if (boundingBox == null || images.isEmpty) {
      return;
    }

    // Calculate dimensions
    final frameSize = GenerateSprite.sizeOfFrame(boundingBox.size, settings);
    final spriteSheetWidth = _calculateSpriteSheetWidth(
      settings,
      images.length,
      frameSize.width,
      settings.paddingLeftPx ?? 0,
    );
    final spriteSheetHeight = _calculateSpriteSheetHeight(
      settings,
      frameSize.height,
      settings.paddingTopPx ?? 0,
      settings.paddingBottomPx ?? 0,
    );

    // Calculate scaling factor for images
    final scalingFactor = switch (settings.constraints) {
      SpriteSizeConstrained() => GenerateSprite.scalingWithBoundingBox(
          settings.constraints as SpriteSizeConstrained, boundingBox,
          images: images),
      SpriteHeightConstrained() => GenerateSprite.scalingFactorForSizeAlongAxis(
          (settings.constraints as SpriteHeightConstrained).heightPx,
          Axis.vertical,
          images: images),
      SpriteWidthConstrained() => GenerateSprite.scalingFactorForSizeAlongAxis(
          (settings.constraints as SpriteWidthConstrained).widthPx,
          Axis.horizontal,
          images: images),
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
      final frameYPos = settings.paddingTopPx ?? 0;

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
  <g transform="translate(${(frameXPos + (settings.paddingLeftPx ?? 0)).toStringAsFixed(2)}, ${frameYPos.toStringAsFixed(2)})">
    <g transform="translate(${relativeOffset.dx.toStringAsFixed(2)}, ${relativeOffset.dy.toStringAsFixed(2)}) scale(${imageScale.toStringAsFixed(6)})">
      $svgContent
    </g>
  </g>
''');
    }

    // Close SVG
    svgBuffer.write('</svg>');

    // Get file name and extension
    final fileName = settings.fileName ?? 'sprite';

    // Save the SVG sprite
    final svgData = Uint8List.fromList(utf8.encode(svgBuffer.toString()));
    try {
      if (settings.path != null) {
        await File('${settings.path}/$fileName.svg').writeAsBytes(svgData);
      } else {
        await (fileSaver ?? FileSaver.instance).saveFile(
          name: fileName,
          bytes: svgData,
          ext: 'svg',
          mimeType: MimeType.other,
        );
      }
    } catch (e) {
      debugPrint('Error saving SVG file: $e');
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
    if ((settings.paddingLeftPx ?? 0) < 0 ||
        (settings.paddingRightPx ?? 0) < 0 ||
        (settings.paddingTopPx ?? 0) < 0 ||
        (settings.paddingBottomPx ?? 0) < 0) {
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
    final paddingPerFrame =
        (settings.paddingLeftPx ?? 0) + (settings.paddingRightPx ?? 0);
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
        return (settings.constraints as SpriteSizeConstrained).heightPx;
      default:
        return frameHeight + topPadding + bottomPadding;
    }
  }
}
