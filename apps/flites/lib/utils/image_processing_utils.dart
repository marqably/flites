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
    try {
      // Show loading overlay while processing
      showLoadingOverlay.value = true;

      final originalImage = await compute(img.decodePng, pngBytes);

      if (originalImage == null) {
        throw Exception('Unable to decode PNG');
      }

      final diagonal =
          sqrt(pow(originalImage.width, 2) + pow(originalImage.height, 2))
              .ceil();

      final canvas = img.Image(
        width: diagonal,
        height: diagonal,
        numChannels: 4,
        format: img.Format.uint8,
      );

      final rotatedImage = await compute(_rotateImageWithArgs, {
        'image': originalImage,
        'angle': angleRadians * 180 / pi,
      });

      final compositeImage = await compute(_compositeImagesWithArgs, {
        'canvas': canvas,
        'rotatedImage': rotatedImage,
      });

      final trimmedImage = await compute(img.trim, compositeImage);
      final encodedPngImage = await compute(img.encodePng, trimmedImage);

      return encodedPngImage;
    } catch (e) {
      debugPrint('Rotation error: $e');
      rethrow;
    } finally {
      showLoadingOverlay.value = false;
    }
  }

  static img.Image _rotateImageWithArgs(Map<String, dynamic> args) {
    return img.copyRotate(args['image'], angle: args['angle']);
  }

  static img.Image _compositeImagesWithArgs(Map<String, img.Image> args) {
    return img.compositeImage(args['canvas']!, args['rotatedImage']!);
  }
}
