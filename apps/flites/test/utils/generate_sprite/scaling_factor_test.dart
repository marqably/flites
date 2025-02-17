import 'dart:typed_data';

import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('GenerateSprite scaling calculations', () {
    late Uint8List imageBytes;
    late List<FlitesImage> testImages;

    setUp(() {
      // Create a 100x100 test image in memory
      final image = img.Image(
        width: 100,
        height: 100,
        numChannels: 4,
        format: img.Format.uint8,
      );
      // Fill with white to ensure it's not empty
      img.fill(image, color: img.ColorRgba8(255, 255, 255, 255));
      imageBytes = Uint8List.fromList(img.encodePng(image));
    });

    group('scalingFactorForSizeAlongAxis', () {
      test('calculates correct horizontal scaling for sequential images', () {
        // Given - Two images placed side by side (total width 200)
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 100,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test2.png',
          )
            ..positionOnCanvas = const Offset(100, 0)
            ..widthOnCanvas = 100,
        ];
        const targetWidth = 300.0;

        // When
        final result = GenerateSprite.scalingFactorForSizeAlongAxis(
          targetWidth,
          Axis.horizontal,
          images: testImages,
        );

        // Then
        expect(result, equals(1.5)); // 300 / 200 = 1.5
      });

      test('calculates correct horizontal scaling for overlapping images', () {
        // Given - Two images with partial overlap (total width 250)
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 150,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test2.png',
          )
            ..positionOnCanvas = const Offset(100, 0)
            ..widthOnCanvas = 150,
        ];
        const targetWidth = 450.0;

        // When
        final result = GenerateSprite.scalingFactorForSizeAlongAxis(
          targetWidth,
          Axis.horizontal,
          images: testImages,
        );

        // Then
        expect(result, equals(1.8)); // 450 / 250 = 1.8
      });

      test('calculates correct vertical scaling for stacked images', () {
        // Given - Two images stacked vertically (total height 200)
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 100,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test2.png',
          )
            ..positionOnCanvas = const Offset(0, 100)
            ..widthOnCanvas = 100,
        ];
        const targetHeight = 300.0;

        // When
        final result = GenerateSprite.scalingFactorForSizeAlongAxis(
          targetHeight,
          Axis.vertical,
          images: testImages,
        );

        // Then
        expect(result, equals(1.5)); // 300 / 200 = 1.5
      });
    });

    group('scalingFactorForSizeBestFit', () {
      test('returns scaling factor based on longest side with multiple images',
          () {
        // Given - Three images in an L shape (total width and height 200)
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 100,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test2.png',
          )
            ..positionOnCanvas = const Offset(100, 0)
            ..widthOnCanvas = 100,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test3.png',
          )
            ..positionOnCanvas = const Offset(0, 100)
            ..widthOnCanvas = 100,
        ];
        const targetSize = Size(300, 300);

        // When
        final result = GenerateSprite.scalingFactorForSizeBestFit(
          targetSize,
          images: testImages,
        );

        // Then
        expect(result, equals(1.5)); // 300 / 200 = 1.5
      });
    });

    group('scalingWithBoundingBox', () {
      test('calculates scaling factor for complex sprite arrangement', () {
        // Given - Multiple images in a complex arrangement (total width 200)
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 100,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test2.png',
          )
            ..positionOnCanvas = const Offset(100, 25)
            ..widthOnCanvas = 100,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test3.png',
          )
            ..positionOnCanvas = const Offset(50, 100)
            ..widthOnCanvas = 100,
        ];

        final boundingBox = BoundingBox(
          position: const Offset(0, 0),
          size: const Size(200, 150),
        );
        final constraints = SpriteSizeConstrained(400, 300);

        // When
        final result = GenerateSprite.scalingWithBoundingBox(
          constraints,
          boundingBox,
          images: testImages,
        );

        // Then
        expect(result, equals(2.0)); // 400 / 200 = 2.0
      });
    });

    group('edge cases', () {
      test('handles single image case', () {
        // Given
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 100,
        ];

        // When
        final result = GenerateSprite.scalingFactorForSizeAlongAxis(
          200,
          Axis.horizontal,
          images: testImages,
        );

        // Then
        expect(result, equals(2.0));
      });

      test('handles zero width images', () {
        // Given
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 0,
        ];

        // When/Then
        expect(
          () => GenerateSprite.scalingFactorForSizeAlongAxis(
            100,
            Axis.horizontal,
            images: testImages,
          ),
          throwsException,
        );
      });

      test('handles empty image list', () {
        // Given
        testImages = [];

        // When/Then
        expect(
          () => GenerateSprite.scalingFactorForSizeAlongAxis(
            100,
            Axis.horizontal,
            images: testImages,
          ),
          throwsException,
        );
      });
    });
  });
}
