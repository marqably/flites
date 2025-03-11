import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';

/// A utility class for working with SVG images.
/// Provides methods for validating SVG data and extracting dimensions.
class SvgUtils {
  /// Checks if the provided data is a valid SVG file
  /// by looking for the SVG XML signature.
  ///
  /// Returns true if the data contains an SVG tag.
  static bool isSvg(Uint8List data) {
    if (data.length < 5) return false;

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
      final widthMatch = RegExp(r'width="([^"]*)"').firstMatch(svgString) ??
          RegExp(r"width='([^']*)'").firstMatch(svgString);
      final heightMatch = RegExp(r'height="([^"]*)"').firstMatch(svgString) ??
          RegExp(r"height='([^']*)'").firstMatch(svgString);

      // Parse dimensions, handling units like px, em, etc.
      double width = _parseSvgDimension(widthMatch?.group(1));
      double height = _parseSvgDimension(heightMatch?.group(1));

      // If viewBox is present but width/height are not, use viewBox dimensions
      if ((width <= 0 || height <= 0) && svgString.contains('viewBox')) {
        final viewBoxMatch =
            RegExp(r'viewBox="([^"]*)"').firstMatch(svgString) ??
                RegExp(r"viewBox='([^']*)'").firstMatch(svgString);

        if (viewBoxMatch != null) {
          final viewBoxParts =
              viewBoxMatch.group(1)?.split(RegExp(r'[ ,]+')) ?? [];

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
    } catch (e) {
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
    if (dimension == null) return 0;

    // Handle percentage values
    if (dimension.endsWith('%')) {
      return 100; // Default size for percentage values
    }

    // Remove units like px, em, etc.
    final numericValue = dimension.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numericValue) ?? 0;
  }

  /// Rotates an SVG image by applying a rotation transform directly to the SVG content.
  ///
  /// This is a simple approach that directly adds a rotation transform to the SVG.
  /// Some content may be cut off after rotation if it extends beyond the original boundaries.
  ///
  /// Returns a new Uint8List containing the rotated SVG data.
  static Future<Uint8List> rotateAndTrimSvg(
      Uint8List svgData, double angleRadians) async {
    try {
      // If angle is close to 0, return the original SVG
      if (angleRadians.abs() < 0.001) {
        return svgData;
      }

      // Convert SVG bytes to string
      final svgString = String.fromCharCodes(svgData);

      // Extract original dimensions
      final size = getSvgSize(svgData);
      final originalWidth = size.width;
      final originalHeight = size.height;

      // Calculate the center point
      final centerX = originalWidth / 2;
      final centerY = originalHeight / 2;

      // Convert angle to degrees for SVG transform
      final angleDegrees = (angleRadians * 180 / pi) % 360;

      // Extract the SVG content (everything between the <svg> and </svg> tags)
      final contentMatch =
          RegExp(r'<svg[^>]*>([\s\S]*)<\/svg>').firstMatch(svgString);
      final svgContent = contentMatch?.group(1) ?? '';

      // Extract all attributes from the original SVG
      final attributesMatch = RegExp(r'<svg([^>]*)>').firstMatch(svgString);
      String originalAttributes = attributesMatch?.group(1) ?? '';

      // Create a new SVG with the original attributes and a rotation transform
      final rotatedSvg = '''
<svg$originalAttributes>
  <g transform="rotate($angleDegrees, $centerX, $centerY)">
    $svgContent
  </g>
</svg>
''';

      // Convert back to Uint8List
      return Uint8List.fromList(utf8.encode(rotatedSvg));
    } catch (e) {
      // If anything goes wrong, return the original SVG data
      debugPrint('Error rotating SVG: $e');
      return svgData;
    }
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
      final viewBoxMatch = RegExp(r'viewBox="([^"]*)"').firstMatch(svgString) ??
          RegExp(r"viewBox='([^']*)'").firstMatch(svgString);

      if (viewBoxMatch != null) {
        final viewBoxParts =
            viewBoxMatch.group(1)?.split(RegExp(r'[ ,]+')) ?? [];

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
    } catch (e) {
      return null;
    }
  }
}
