import 'dart:io';
import 'dart:typed_data';

import 'package:flites/types/export_settings.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/bounding_box_utils.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('GenerateSprite.separateSpriteImages', () {
    late Uint8List imageBytes;
    late List<FlitesImage> testImages;
    late BoundingBox testBoundingBox;

    setUp(() {
      // Load the test image
      final testImageFile = File('test/utils/test_image.png');
      imageBytes = testImageFile.readAsBytesSync();
    });

    group('height constrained', () {
      test('scales image correctly with height constraint and padding', () {
        // Given
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(10, 20)
            ..widthOnCanvas = 100,
        ];

        testBoundingBox = BoundingBox(
          position: const Offset(10, 20),
          size: const Size(100, 50),
        );

        final settings = ExportSettings(
          heightPx: 100,
          paddingTopPx: 10,
          paddingBottomPx: 10,
        );

        // When
        final result = GenerateSprite.separateSpriteImages(
          testImages,
          testBoundingBox,
          settings.maxDimensionsAfterPadding,
          settings,
        );

        // Then
        expect(result, isNotEmpty);
        expect(result.length, equals(1));
        expect(
            result.first.height, equals(100)); // Full height including padding
      });

      test('handles multiple images with correct positioning', () {
        // Given
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 50,
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test2.png',
          )
            ..positionOnCanvas = const Offset(50, 10)
            ..widthOnCanvas = 50,
        ];

        testBoundingBox = BoundingBox(
          position: const Offset(0, 0),
          size: const Size(100, 60),
        );

        final settings = ExportSettings(
          heightPx: 120,
          paddingTopPx: 10,
          paddingBottomPx: 10,
        );

        // When
        final result = GenerateSprite.separateSpriteImages(
          testImages,
          testBoundingBox,
          settings.maxDimensionsAfterPadding,
          settings,
        );

        // Then
        expect(result.length, equals(2));
        expect(result[0].height, equals(120)); // Full height with padding
        expect(result[1].height, equals(120)); // Full height with padding
      });
    });

    group('width constrained', () {
      test('scales image correctly with width constraint and padding', () {
        // Given
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(10, 20)
            ..widthOnCanvas = 100,
        ];

        testBoundingBox = BoundingBox(
          position: const Offset(10, 20),
          size: const Size(100, 50),
        );

        final settings = ExportSettings(
          widthPx: 200,
          paddingLeftPx: 20,
          paddingRightPx: 20,
        );

        // When
        final result = GenerateSprite.separateSpriteImages(
          testImages,
          testBoundingBox,
          settings.maxDimensionsAfterPadding,
          settings,
        );

        // Then
        expect(result, isNotEmpty);
        expect(result.length, equals(1));
        expect(result.first.width, equals(200)); // Full width including padding
      });
    });

    group('size constrained', () {
      test('scales image correctly with both width and height constraints', () {
        // Given
        testImages = [
          FlitesImage.scaled(
            imageBytes,
            scalingFactor: 1.0,
            originalName: 'test1.png',
          )
            ..positionOnCanvas = const Offset(10, 20)
            ..widthOnCanvas = 100,
        ];

        testBoundingBox = BoundingBox(
          position: const Offset(10, 20),
          size: const Size(100, 50),
        );

        final settings = ExportSettings(
          widthPx: 200,
          heightPx: 100,
          paddingLeftPx: 20,
          paddingRightPx: 20,
          paddingTopPx: 10,
          paddingBottomPx: 10,
        );

        // When
        final result = GenerateSprite.separateSpriteImages(
          testImages,
          testBoundingBox,
          settings.maxDimensionsAfterPadding,
          settings,
        );

        // Then
        expect(result, isNotEmpty);
        expect(result.length, equals(1));
        expect(result.first.width, equals(200)); // Full width including padding
        expect(
            result.first.height, equals(100)); // Full height including padding
      });
    });

    group('edge cases', () {
      test('handles empty image list', () {
        // Given
        testImages = [];
        testBoundingBox = BoundingBox(
          position: const Offset(0, 0),
          size: const Size(100, 50),
        );

        final settings = ExportSettings(
          widthPx: 200,
          heightPx: 100,
        );

        // When
        final result = GenerateSprite.separateSpriteImages(
          testImages,
          testBoundingBox,
          settings.maxDimensionsAfterPadding,
          settings,
        );

        // Then
        expect(result, isEmpty);
      });

      test('skips images that fail to decode', () {
        // Given
        // Create a minimal valid PNG that we'll corrupt
        final emptyImage = img.Image(width: 1, height: 1);
        final validImageBytes = img.encodePng(emptyImage);

        // Corrupt the image data but keep the header and dimensions intact
        final corruptedBytes = List<int>.from(validImageBytes);
        for (var i = 32; i < corruptedBytes.length; i++) {
          corruptedBytes[i] = 0;
        }

        testImages = [
          FlitesImage.scaled(
            Uint8List.fromList(corruptedBytes),
            scalingFactor: 1.0,
            originalName: 'test.png',
          )
            ..positionOnCanvas = const Offset(0, 0)
            ..widthOnCanvas = 100,
        ];

        testBoundingBox = BoundingBox(
          position: const Offset(0, 0),
          size: const Size(100, 50),
        );

        final settings = ExportSettings(
          widthPx: 200,
          heightPx: 100,
        );

        // When
        final result = GenerateSprite.separateSpriteImages(
          testImages,
          testBoundingBox,
          settings.maxDimensionsAfterPadding,
          settings,
        );

        // Then
        expect(result, isEmpty);
      });
    });
  });
}
