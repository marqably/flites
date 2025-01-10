import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// A utility class for working with images.
/// Holds methods for rotating images.
class ImageProcessingUtils {
  static Future<Uint8List> rotateImage(
      Uint8List pngBytes, double angleRadians) async {
    final originalImage = img.decodePng(pngBytes);

    if (originalImage == null) {
      throw Exception('Unable to decode PNG');
    }

    final longestSide = max(originalImage.width, originalImage.height) * 2;

    final canvas = img.Image(
      width: longestSide,
      height: longestSide,
      numChannels: 4,
      format: img.Format.uint8,
    );

    final rotatedImage =
        img.copyRotate(originalImage, angle: angleRadians * 180 / pi);
    final composite = img.compositeImage(canvas, rotatedImage);
    final trimmedImage = img.trim(composite);

    return Uint8List.fromList(img.encodePng(trimmedImage));
  }
}
