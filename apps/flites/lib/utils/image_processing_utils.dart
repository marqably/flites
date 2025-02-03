import 'dart:math';
import 'package:flites/widgets/loading_overlay/loading_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// A utility class for working with images.
/// Holds methods for rotating images.
class ImageProcessingUtils {
  /// Rotates an image by the given angle in radians.
  /// The computation of each step is done in an isolate.
  static Future<Uint8List> rotateInIsolates(
    Uint8List pngBytes,
    double angleRadians,
  ) async {
    return withLoadingOverlay(() async {
      return compute(_processRotation, {
        'pngBytes': pngBytes,
        'angleRadians': angleRadians,
      });
    });
  }

  // Handles the actual image rotation processing
  static Uint8List _processRotation(Map<String, dynamic> args) {
    final pngBytes = args['pngBytes'] as Uint8List;
    final angleRadians = args['angleRadians'] as double;

    // 1. Decode image
    final originalImage = img.decodePng(pngBytes);
    if (originalImage == null) {
      throw Exception('Unable to decode PNG');
    }

    // 2. Calculate diagonal
    final diagonal = sqrt(
      pow(originalImage.width, 2) + pow(originalImage.height, 2),
    ).ceil();

    // 3. Create canvas
    final canvas = img.Image(
      width: diagonal,
      height: diagonal,
      numChannels: 4,
      format: img.Format.uint8,
    );

    // 4. Rotate image
    final rotatedImage = img.copyRotate(
      originalImage,
      angle: angleRadians * 180 / pi,
    );

    // 5. Composite images
    final compositeImage = img.compositeImage(canvas, rotatedImage);

    // 6. Trim and encode
    final trimmedImage = img.trim(compositeImage);
    return Uint8List.fromList(img.encodePng(trimmedImage));
  }
}
