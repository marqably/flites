import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../widgets/overlays/loading_overlay.dart';

/// Result of a rotation operation, including the trim offset so the caller
/// can compensate for the asymmetric crop and keep the image centered.
class RotationResult {
  RotationResult({
    required this.imageBytes,
    required this.trimCenterOffsetX,
    required this.trimCenterOffsetY,
  });

  final Uint8List imageBytes;

  /// How much the center shifted (in raw pixels) due to trimming.
  final double trimCenterOffsetX;
  final double trimCenterOffsetY;
}

/// A utility class for working with images.
/// Holds methods for rotating images.
class ImageProcessingUtils {
  // Private constructor to prevent instantiation
  ImageProcessingUtils._();

  /// Rotates an image by the given angle in radians.
  /// The computation of each step is done in an isolate.
  static Future<RotationResult> rotateInIsolates(
    Uint8List pngBytes,
    double angleRadians,
  ) async =>
      withLoadingOverlay(
        () async {
          final result = await compute(_processRotationIsolate, {
            'pngBytes': pngBytes,
            'angleRadians': angleRadians,
          });
          return RotationResult(
            imageBytes: result['imageBytes'] as Uint8List,
            trimCenterOffsetX: result['trimCenterOffsetX'] as double,
            trimCenterOffsetY: result['trimCenterOffsetY'] as double,
          );
        },
      );

  /// Isolate entry point — accepts and returns Maps because Dart isolates
  /// can only pass primitive types across the boundary.
  static Map<String, dynamic> _processRotationIsolate(
    Map<String, dynamic> args,
  ) {
    final result = processRotation(
      args['pngBytes'] as Uint8List,
      args['angleRadians'] as double,
    );
    return {
      'imageBytes': result.imageBytes,
      'trimCenterOffsetX': result.trimCenterOffsetX,
      'trimCenterOffsetY': result.trimCenterOffsetY,
    };
  }

  /// Rotates a PNG image by [angleRadians], trims transparent borders,
  /// and returns the result with trim center offsets.
  static RotationResult processRotation(
    Uint8List pngBytes,
    double angleRadians,
  ) {
    final originalImage = getImageFromBytes(pngBytes);
    if (originalImage == null) {
      throw Exception('Unable to decode PNG');
    }

    // copyRotate produces a symmetric output centered on the original center
    final rotatedImage = img.copyRotate(
      originalImage,
      angle: angleRadians * 180 / pi,
      interpolation: img.Interpolation.cubic,
    );

    // Find the non-transparent bounding box
    final trimRect = img.findTrim(rotatedImage);
    final trimX = trimRect[0];
    final trimY = trimRect[1];
    final trimWidth = trimRect[2];
    final trimHeight = trimRect[3];

    // Calculate how much the center shifted due to asymmetric trimming.
    // copyRotate center = (width/2, height/2) = the original image center.
    // Trim center = (trimX + trimWidth/2, trimY + trimHeight/2).
    final trimCenterOffsetX =
        (trimX + trimWidth / 2.0) - rotatedImage.width / 2.0;
    final trimCenterOffsetY =
        (trimY + trimHeight / 2.0) - rotatedImage.height / 2.0;

    final trimmedImage = img.copyCrop(
      rotatedImage,
      x: trimX,
      y: trimY,
      width: trimWidth,
      height: trimHeight,
    );

    return RotationResult(
      imageBytes: Uint8List.fromList(img.encodePng(trimmedImage)),
      trimCenterOffsetX: trimCenterOffsetX,
      trimCenterOffsetY: trimCenterOffsetY,
    );
  }

  static img.Image? getImageFromBytes(Uint8List bytes) {
    final originalImage = img.decodePng(bytes);

    return originalImage;
  }

  static Uint8List trimPngAsBytes(Uint8List bytes) {
    final originalImage = getImageFromBytes(bytes);
    if (originalImage == null) {
      throw Exception('Unable to decode PNG');
    }

    final trimmedImage = img.trim(originalImage);

    return Uint8List.fromList(img.encodePng(trimmedImage));
  }
}
