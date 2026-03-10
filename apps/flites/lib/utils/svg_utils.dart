import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';

import '../states/source_files_state.dart';
import '../types/svg_data.dart';
import 'image_processing_utils.dart';
import 'png_utils.dart';

/// A utility class for working with SVG images.
/// Provides methods for validating SVG data and extracting dimensions.
class SvgUtils {
  // Private constructor to prevent instantiation
  SvgUtils._();
  /// Loops through all images in the project and returns the percentage of
  /// SVG images in the project. This can then be used to determine if we
  /// should show the SVG export option.
  ///
  /// Returns a double between 0 and 100.
  static double get percentageOfSvgImagesInProject {
    final totalImages = SourceFilesState.projectSourceFiles.rows
        .fold(0, (sum, row) => sum + row.images.length);
    final svgImages = SourceFilesState.projectSourceFiles.rows.fold(
      0,
      (sum, row) =>
          sum + row.images.where((image) => isSvg(image.image)).length,
    );

    if (totalImages == 0) {
      return 0;
    }

    return (svgImages / totalImages) * 100;
  }

  /// Checks if all images in the project are SVGs.
  ///
  /// Returns true if all images in the project are SVGs.
  static bool get allImagesInProjectAreSvg =>
      percentageOfSvgImagesInProject == 100;

  /// Checks if the provided data is a valid SVG file
  /// by looking for the SVG XML signature.
  ///
  /// Returns true if the data contains an SVG tag.
  static bool isSvg(Uint8List data) {
    if (data.length < 5) {
      return false;
    }

    // Convert the first part of the data to a string to check for SVG signature
    // We only need to check the beginning of the file, not the entire content
    final header =
        String.fromCharCodes(data.sublist(0, data.length.clamp(0, 500)));

    // Look for <svg tag which indicates an SVG file
    return header.contains('<svg');
  }

  /// Extracts the width and height from SVG data.
  ///
  /// This method attempts to parse dimensions in the following order:
  /// 1. Explicit width/height attributes
  /// 2. ViewBox dimensions if width/height are not available
  /// 3. Default size (100x100) if neither is available
  ///
  /// Returns a Size object with the extracted dimensions.
  static Size getSvgSize(Uint8List data) {
    try {
      // Convert to string to parse the SVG
      final svgString = String.fromCharCodes(data);

      // Extract width and height using regex
      final widthMatch = RegExp('width="([^"]*)"').firstMatch(svgString) ??
          RegExp("width='([^']*)'").firstMatch(svgString);
      final heightMatch = RegExp('height="([^"]*)"').firstMatch(svgString) ??
          RegExp("height='([^']*)'").firstMatch(svgString);

      // Parse dimensions, handling units like px, em, etc.
      double width = _parseSvgDimension(widthMatch?.group(1));
      double height = _parseSvgDimension(heightMatch?.group(1));

      // If viewBox is present but width/height are not, use viewBox dimensions
      if ((width <= 0 || height <= 0) && svgString.contains('viewBox')) {
        final viewBoxMatch =
            RegExp('viewBox="([^"]*)"').firstMatch(svgString) ??
                RegExp("viewBox='([^']*)'").firstMatch(svgString);

        if (viewBoxMatch != null) {
          final viewBoxParts =
              viewBoxMatch.group(1)?.split(RegExp('[ ,]+')) ?? [];

          if (viewBoxParts.length >= 4) {
            final viewBoxWidth = double.tryParse(viewBoxParts[2]) ?? 0;
            final viewBoxHeight = double.tryParse(viewBoxParts[3]) ?? 0;

            width = width <= 0 ? viewBoxWidth : width;
            height = height <= 0 ? viewBoxHeight : height;
          }
        }
      }

      // Use default dimensions if we couldn't determine valid ones
      width = width > 0 ? width : 100;
      height = height > 0 ? height : 100;

      return Size(width, height);
    } on Exception {
      return const Size(100, 100); // Default size
    }
  }

  /// Helper method to parse SVG dimension values.
  ///
  /// Handles various formats including:
  /// - Plain numbers: "100"
  /// - Numbers with units: "100px", "10em"
  /// - Percentage values: "50%"
  ///
  /// Returns the parsed numeric value or 0 if parsing fails.
  static double _parseSvgDimension(String? dimension) {
    if (dimension == null) {
      return 0;
    }

    // Handle percentage values
    if (dimension.endsWith('%')) {
      return 100; // Default size for percentage values
    }

    // Remove units like px, em, etc.
    final numericValue = dimension.replaceAll(RegExp('[^0-9.]'), '');
    return double.tryParse(numericValue) ?? 0;
  }

  /// Rotates an SVG image by applying a rotation transform directly to the SVG content.
  ///
  /// This is a simple approach that directly adds a rotation transform to the SVG.
  /// Some content may be cut off after rotation if it extends beyond the original boundaries.
  ///
  /// Returns a new Uint8List containing the rotated SVG data.
  static Future<Uint8List> rotateAndTrimSvg(
    Uint8List svgData,
    double angleRadians,
  ) async {
    try {
      if (!_validateMinAngleRadians(angleRadians)) {
        return svgData;
      }

      final svg = SvgData.fromSvgData(svgData);

      // Check if this SVG was previously rotated by us (has stored originals).
      // This prevents the bounding box from growing with each rotation —
      // we always compute the box from the original content size.
      final storedW = getDataAttribute(svg.attributes, 'data-orig-w');
      final storedH = getDataAttribute(svg.attributes, 'data-orig-h');
      final storedCx = getDataAttribute(svg.attributes, 'data-orig-cx');
      final storedCy = getDataAttribute(svg.attributes, 'data-orig-cy');

      final Size originalContentSize;
      final Offset rotationCenter;
      final String innerContent;
      final double totalAngleDegrees;

      if (storedW != null && storedH != null) {
        // Compose rotations: extract the existing angle, strip the old
        // rotation wrapper, and combine into a single transform.
        originalContentSize = Size(storedW, storedH);
        rotationCenter = Offset(
          storedCx ?? svg.center.dx,
          storedCy ?? svg.center.dy,
        );
        final existingDegrees =
            extractExistingRotationDegrees(svg.content);
        totalAngleDegrees = existingDegrees + angleToDegrees(angleRadians);
        innerContent = stripRotationWrapper(svg.content);
      } else {
        // First rotation — use current dimensions as the baseline.
        originalContentSize = svg.sizeFromHeightAndWidth;
        rotationCenter = svg.center;
        totalAngleDegrees = angleToDegrees(angleRadians);
        innerContent = svg.content;
      }

      // Calculate bounding box from the ORIGINAL content size
      final totalAngleRadians = totalAngleDegrees * pi / 180;
      final rotatedBoxSize =
          rotateBox(originalContentSize, totalAngleRadians);

      // Preserve or add data-orig-* attributes
      var attributes = ensureOriginalSizeAttributes(
        svg.attributes,
        originalContentSize,
        rotationCenter,
      );

      // Set viewBox and size to the rotated bounding box, centered on
      // the original rotation center
      attributes = resizeAndCenterAttributes(
        attributes,
        targetSize: rotatedBoxSize,
        centerX: rotationCenter.dx,
        centerY: rotationCenter.dy,
      );

      // Build the final SVG with a single rotation transform
      final finalSvg = svgStringFromParts(
        attributes: attributes,
        contentWrapper:
            '<g transform="rotate(${totalAngleDegrees % 360}, ${rotationCenter.dx}, ${rotationCenter.dy})">',
        contentWrapperClosingTag: '</g>',
        content: innerContent,
      );

      return Uint8List.fromList(utf8.encode(finalSvg));
    } on Exception catch (e) {
      debugPrint('Error rotating SVG: $e');
      return svgData;
    }
  }

  static bool _validateMinAngleRadians(double angleRadians) =>
      angleRadians.abs() > 0.001;

  /// Gets a numeric data-* attribute value from an SVG attributes string.
  static double? getDataAttribute(String attributes, String name) {
    final match = RegExp('$name="([^"]*)"').firstMatch(attributes);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  /// Adds data-orig-* attributes to preserve the original content
  /// dimensions through multiple rotations.
  static String ensureOriginalSizeAttributes(
    String attributes,
    Size contentSize,
    Offset center,
  ) {
    if (attributes.contains('data-orig-w=')) {
      return attributes;
    }
    return '$attributes'
        ' data-orig-w="${contentSize.width}"'
        ' data-orig-h="${contentSize.height}"'
        ' data-orig-cx="${center.dx}"'
        ' data-orig-cy="${center.dy}"';
  }

  /// Extracts the rotation angle in degrees from a `<g transform="rotate(...)"`
  /// wrapper at the start of the SVG content.
  static double extractExistingRotationDegrees(String content) {
    final match = RegExp(
      r'<g\s+transform="rotate\(\s*([^,\s]+)',
    ).firstMatch(content.trim());
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 0;
    }
    return 0;
  }

  /// Strips the outermost rotation `<g>` wrapper from SVG content,
  /// returning the inner content.
  static String stripRotationWrapper(String content) {
    final trimmed = content.trim();
    final openMatch = RegExp(
      r'^<g\s+transform="rotate\([^)]*\)">\s*',
    ).firstMatch(trimmed);
    if (openMatch == null) {
      return content;
    }

    var inner = trimmed.substring(openMatch.end);
    // Remove the last </g> which is the rotation wrapper's closing tag
    final lastClose = inner.lastIndexOf('</g>');
    if (lastClose >= 0) {
      inner = inner.substring(0, lastClose) + inner.substring(lastClose + 4);
    }
    return inner.trim();
  }

  static double angleToDegrees(double angleInRadians) =>
      (angleInRadians * 180 / pi) % 360;

  static Offset getCenterOfRect(Rect? rect) {
    final originalViewboxWidth = rect?.width ?? 100;
    final originalViewboxHeight = rect?.height ?? 100;
    final originalViewboxX = rect?.left ?? 0;
    final originalViewboxY = rect?.top ?? 0;

    // Calculate the center point
    final centerX = originalViewboxX + originalViewboxWidth / 2;
    final centerY = originalViewboxY + originalViewboxHeight / 2;

    return Offset(centerX, centerY);
  }

  static String resizeAndCenterAttributes(
    String svgAttributes, {
    required Size targetSize,
    required double centerX,
    required double centerY,
  }) {
    final attributesWithViewbox = updateSvgViewBox(
      svgAttributes,
      width: targetSize.width.ceil(),
      height: targetSize.height.ceil(),
      x: (centerX - (targetSize.width / 2)).ceil(),
      y: (centerY - (targetSize.height / 2)).ceil(),
    );

    final attributesWithSize = updateSvgSize(
      attributesWithViewbox,
      targetSize.width.ceil(),
      targetSize.height.ceil(),
    );

    return attributesWithSize;
  }

  static Future<Size> sizeFromTrimmedPng(
    String svgString, {
    required Size targetSize,
  }) async {
    final png = await svgStringToPngBytes(
      svgString,
      targetSize.width,
      targetSize.height,
    );

    final trimmedPng = ImageProcessingUtils.trimPngAsBytes(png);

    final pngSize = PngUtils.getSizeOfPng(trimmedPng.buffer.asByteData());

    return pngSize;
  }

  static Size rotateBox(Size size, double angleRadians) {
    final absCos = cos(angleRadians).abs();
    final absSin = sin(angleRadians).abs();

    return Size(
      size.width * absCos + size.height * absSin,
      size.width * absSin + size.height * absCos,
    );
  }

  static String svgStringFromParts({
    String attributes = '',
    String contentWrapper = '',
    String contentWrapperClosingTag = '',
    String content = '',
  }) {
    assert(
      contentWrapper.isNotEmpty == contentWrapperClosingTag.isNotEmpty,
      'If a content wrapper is provided, a matching closing tag must be passed.',
    );

    return '''
<svg$attributes>
    $contentWrapper
    $content
    $contentWrapperClosingTag
</svg>
''';
  }

  /// Extracts the attributes from SVG data.
  ///
  /// This method parses the attributes from the SVG and returns them as a String.
  static String getAttributes(String svgString) {
    // Extract all attributes from the original SVG
    final attributesMatch = RegExp('<svg([^>]*)>').firstMatch(svgString);

    final String attributes = attributesMatch?.group(1) ?? '';

    return attributes;
  }

  /// Extracts the content from SVG data.
  ///
  /// This method parses the content from the SVG and returns it as a String.
  static String getContent(String svgString) {
    final contentMatch =
        RegExp(r'<svg[^>]*>([\s\S]*)<\/svg>').firstMatch(svgString);
    return contentMatch?.group(1) ?? '';
  }

  /// Extracts the viewBox from SVG data.
  ///
  /// This method parses the viewBox attribute from the SVG and returns it as a Rect.
  /// If no viewBox is defined, returns null.
  static Rect? getViewBox(Uint8List data) {
    try {
      // Convert to string to parse the SVG
      final svgString = String.fromCharCodes(data);

      // Extract viewBox using regex
      final viewBoxMatch = RegExp('viewBox="([^"]*)"').firstMatch(svgString) ??
          RegExp("viewBox='([^']*)'").firstMatch(svgString);

      if (viewBoxMatch != null) {
        final viewBoxParts =
            viewBoxMatch.group(1)?.split(RegExp('[ ,]+')) ?? [];

        if (viewBoxParts.length >= 4) {
          final x = double.tryParse(viewBoxParts[0]) ?? 0;
          final y = double.tryParse(viewBoxParts[1]) ?? 0;
          final width = double.tryParse(viewBoxParts[2]) ?? 0;
          final height = double.tryParse(viewBoxParts[3]) ?? 0;

          if (width > 0 && height > 0) {
            return Rect.fromLTWH(x, y, width, height);
          }
        }
      }

      // If no viewBox is found, try to create one from width/height
      final size = getSvgSize(data);
      return Rect.fromLTWH(0, 0, size.width, size.height);
    } on Exception {
      return null;
    }
  }

  /// Updates or adds a viewBox attribute to the root svg tag of an SVG string.
  ///
  /// Takes an svgString, desired integer width, and height.
  /// If a viewBox attribute exists in the root svg tag, it's replaced.
  /// If no viewBox attribute exists, it's added.
  /// The format will be "0 0 width height".
  ///
  /// Returns the modified SVG string, or the original string if no svg tag is found.
  static String updateSvgViewBox(
    String svgAttributes, {
    required int width,
    required int height,
    required int x,
    required int y,
  }) {
    // Define the target viewBox string
    final String newViewBoxAttribute = 'viewBox="$x $y $width $height"';

    // Regex to find an existing viewBox attribute (case-insensitive)
    // This handles viewBox="...", potentially with whitespace around '='
    final RegExp viewBoxRegex = RegExp(
      r'viewBox\s*=\s*"[^"]*"', // Matches viewBox="anything_not_a_quote"
      caseSensitive: false,
    );

    String updatedSvgTag;

    if (viewBoxRegex.hasMatch(svgAttributes)) {
      // Case 1: viewBox exists - replace it
      updatedSvgTag =
          svgAttributes.replaceFirst(viewBoxRegex, newViewBoxAttribute);
    } else {
      updatedSvgTag = '$svgAttributes $newViewBoxAttribute';
    }

    return updatedSvgTag;
  }

  static String updateSvgSize(String svgAttributes, int width, int height) {
    // Define the target viewBox string
    final String newWidthAttribute = 'width="$width"';
    final String newHeightAttribute = 'height="$height"';

    final RegExp widthRegex = RegExp(
      r'width\s*=\s*"[^"]*"',
      caseSensitive: false,
    );

    final RegExp heightRegex = RegExp(
      r'height\s*=\s*"[^"]*"',
      caseSensitive: false,
    );

    String updatedSvgTag;

    if (widthRegex.hasMatch(svgAttributes)) {
      updatedSvgTag = svgAttributes.replaceFirst(widthRegex, newWidthAttribute);
    } else {
      updatedSvgTag = '$svgAttributes $newWidthAttribute';
    }

    if (heightRegex.hasMatch(svgAttributes)) {
      updatedSvgTag =
          updatedSvgTag.replaceFirst(heightRegex, newHeightAttribute);
    } else {
      updatedSvgTag = '$updatedSvgTag $newHeightAttribute';
    }

    return updatedSvgTag;
  }

// With the following imports:
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
  static Future<Uint8List> svgStringToPngBytes(
    // The SVG string
    String svgStringContent,
    // The target width of the output image
    double targetWidth,
    // The target height of the output image
    double targetHeight,
  ) async {
    // const VectorGraphicUtilities vg = VectorGraphicUtilities.;

    final SvgStringLoader svgStringLoader = SvgStringLoader(svgStringContent);
    final PictureInfo pictureInfo = await vg.loadPicture(svgStringLoader, null);
    final ui.Picture picture = pictureInfo.picture;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(targetWidth, targetHeight)),
    )
      ..scale(
        targetWidth / pictureInfo.size.width,
        targetHeight / pictureInfo.size.height,
      )
      ..drawPicture(picture);
    final ui.Image imgByteData = await recorder
        .endRecording()
        .toImage(targetWidth.ceil(), targetHeight.ceil());
    final ByteData? bytesData =
        await imgByteData.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageData = bytesData?.buffer.asUint8List() ?? Uint8List(0);
    pictureInfo.picture.dispose();
    return imageData;
  }
}
