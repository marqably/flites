import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flites/utils/image_processing_utils.dart';
import 'package:flites/widgets/rotation/rotation_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

/// Creates a simple test PNG with a colored rectangle on a transparent
/// background. The rectangle is offset from center to make trim asymmetry
/// detectable.
Uint8List createTestPng({int width = 200, int height = 300}) {
  final image = img.Image(width: width, height: height, numChannels: 4);

  // Draw a colored rectangle that is NOT centered, so trim will be asymmetric
  // after rotation. This is realistic — game sprites are rarely perfectly
  // centered in their bounding box.
  final rectLeft = (width * 0.2).toInt();
  final rectTop = (height * 0.1).toInt();
  final rectRight = (width * 0.8).toInt();
  final rectBottom = (height * 0.7).toInt();

  for (int y = rectTop; y < rectBottom; y++) {
    for (int x = rectLeft; x < rectRight; x++) {
      image.setPixelRgba(x, y, 255, 100, 100, 255);
    }
  }

  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  group('RotationResult', () {
    test('holds image bytes and trim offsets', () {
      final result = RotationResult(
        imageBytes: Uint8List.fromList([1, 2, 3]),
        trimCenterOffsetX: 1.5,
        trimCenterOffsetY: -2.3,
      );

      expect(result.imageBytes, hasLength(3));
      expect(result.trimCenterOffsetX, 1.5);
      expect(result.trimCenterOffsetY, -2.3);
    });
  });

  group('ImageProcessingUtils', () {
    group('getImageFromBytes', () {
      test('decodes a valid PNG', () {
        final png = createTestPng();
        final decoded = ImageProcessingUtils.getImageFromBytes(png);

        expect(decoded, isNotNull);
        expect(decoded!.width, 200);
        expect(decoded.height, 300);
      });

      test('returns null for invalid data', () {
        final invalid = Uint8List.fromList([0, 1, 2, 3]);
        final decoded = ImageProcessingUtils.getImageFromBytes(invalid);

        expect(decoded, isNull);
      });
    });

    group('trimPngAsBytes', () {
      test('trims transparent borders', () {
        final png = createTestPng();
        final trimmed = ImageProcessingUtils.trimPngAsBytes(png);

        // The trimmed image should be smaller since the test image has
        // transparent borders around the colored rectangle
        final originalSize = img.decodePng(png)!;
        final trimmedSize = img.decodePng(trimmed)!;

        expect(trimmedSize.width, lessThan(originalSize.width));
        expect(trimmedSize.height, lessThan(originalSize.height));
      });

      test('throws on invalid data', () {
        expect(
          () => ImageProcessingUtils.trimPngAsBytes(
            Uint8List.fromList([0, 1, 2]),
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });

  group('processRotation', () {
    test('produces valid PNG output', () {
      final png = createTestPng();
      final result = ImageProcessingUtils.processRotation(png, pi / 4);

      expect(result.imageBytes, isNotEmpty);
      expect(img.decodePng(result.imageBytes), isNotNull);
    });

    test('returns non-zero trim offset for asymmetric image', () {
      final png = createTestPng();
      final result = ImageProcessingUtils.processRotation(png, pi / 4);

      // Our test image has an off-center rectangle, so trimming after
      // rotation should produce a non-zero center offset
      expect(
        result.trimCenterOffsetX != 0 || result.trimCenterOffsetY != 0,
        isTrue,
      );
    });

    test('90 degree rotation swaps dimensions approximately', () {
      final png = createTestPng();
      final result = ImageProcessingUtils.processRotation(png, pi / 2);

      final rotatedImage = img.decodePng(result.imageBytes)!;

      // The colored rect is roughly 120x180, so after 90° it should be ~180x120
      expect(rotatedImage.width, greaterThan(rotatedImage.height));
    });

    test('throws on invalid PNG data', () {
      expect(
        () => ImageProcessingUtils.processRotation(
          Uint8List.fromList([0, 1, 2]),
          pi / 4,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('longestSideSize', () {
    test('returns width when wider', () {
      expect(longestSideSize(const Size(200, 100)), 200);
    });

    test('returns height when taller', () {
      expect(longestSideSize(const Size(100, 200)), 200);
    });

    test('returns either when square', () {
      expect(longestSideSize(const Size(100, 100)), 100);
    });
  });
}
