import 'package:flites/utils/generate_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenerateSprite.sizeOfFrame', () {
    group('height constrained', () {
      test('maintains aspect ratio with height constraint', () {
        // Given
        const boundingBoxSize = Size(200, 100); // 2:1 aspect ratio
        final settings = ExportSettings.heightConstrained(
          heightPx: 100,
          paddingTopPx: 10,
          paddingBottomPx: 10,
        );

        // When
        final result = GenerateSprite.sizeOfFrame(boundingBoxSize, settings);

        // Then
        expect(result.height, equals(100)); // Total height including padding
        expect(result.width,
            equals(160)); // Based on available height (80) * aspect ratio (2)
      });

      test('includes vertical margins in calculations', () {
        // Given
        const boundingBoxSize = Size(100, 50); // 2:1 aspect ratio
        final settings = ExportSettings.heightConstrained(
          heightPx: 100,
          paddingTopPx: 20,
          paddingBottomPx: 30,
        );

        // When
        final result = GenerateSprite.sizeOfFrame(boundingBoxSize, settings);

        // Then
        expect(result.height, equals(100)); // Total height including padding
        expect(result.width,
            equals(100)); // Based on available height (50) * aspect ratio (2)
      });
    });

    group('width constrained', () {
      test('maintains aspect ratio with width constraint', () {
        // Given
        const boundingBoxSize = Size(200, 100); // 2:1 aspect ratio
        final settings = ExportSettings.widthConstrained(
          widthPx: 400,
          paddingLeftPx: 20,
          paddingRightPx: 20,
        );

        // When
        final result = GenerateSprite.sizeOfFrame(boundingBoxSize, settings);

        // Then
        expect(result.width, equals(400)); // Original width + padding
        expect(result.height, equals(200)); // Maintains 2:1 aspect ratio
      });

      test('includes horizontal margins in calculations', () {
        // Given
        const boundingBoxSize = Size(100, 50); // 2:1 aspect ratio
        final settings = ExportSettings.widthConstrained(
          widthPx: 200,
          paddingLeftPx: 30,
          paddingRightPx: 20,
        );

        // When
        final result = GenerateSprite.sizeOfFrame(boundingBoxSize, settings);

        // Then
        expect(result.width, equals(200)); // Original width + padding
        expect(result.height, equals(100)); // Maintains aspect ratio
      });
    });

    group('size constrained', () {
      test('uses exact dimensions from settings', () {
        // Given
        const boundingBoxSize = Size(200, 100);
        final settings = ExportSettings.sizeConstrained(
          widthPx: 400,
          heightPx: 300,
          paddingLeftPx: 20,
          paddingRightPx: 20,
          paddingTopPx: 10,
          paddingBottomPx: 10,
        );

        // When
        final result = GenerateSprite.sizeOfFrame(boundingBoxSize, settings);

        // Then
        expect(result.width, equals(400));
        expect(result.height, equals(300));
      });

      test('includes all margins in calculations', () {
        // Given
        const boundingBoxSize = Size(100, 50);
        final settings = ExportSettings.sizeConstrained(
          widthPx: 200,
          heightPx: 100,
          paddingLeftPx: 25,
          paddingRightPx: 25,
          paddingTopPx: 15,
          paddingBottomPx: 15,
        );

        // When
        final result = GenerateSprite.sizeOfFrame(boundingBoxSize, settings);

        // Then
        expect(result.width, equals(200)); // Width including 50px total padding
        expect(
            result.height, equals(100)); // Height including 30px total padding
      });
    });
  });
}
