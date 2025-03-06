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
}
