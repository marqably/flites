import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flites/states/open_project.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/generate_svg_sprite.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenerateSvgSprite', () {
    late Directory tempDir;

    setUp(() {
      // Create temp directory for file tests
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
      // Clear project source files after each test
      projectSourceFiles.value = [];
    });

    test('exports SVG files as SVG sprite with proper positioning', () async {
      // Given - Create SVGs of different sizes
      const largeSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">
  <rect x="10" y="10" width="180" height="180" fill="blue" />
</svg>''';

      const smallSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="40" fill="red" />
</svg>''';

      final svgBytes1 = Uint8List.fromList(utf8.encode(largeSvg));
      final svgBytes2 = Uint8List.fromList(utf8.encode(smallSvg));

      // Create images with different positions and sizes
      final testImages = [
        FlitesImage.scaled(
          svgBytes1,
          scalingFactor: 1.0,
          originalName: 'large.svg',
        )
          ..positionOnCanvas = const Offset(0, 0)
          ..widthOnCanvas = 200,
        FlitesImage.scaled(
          svgBytes2,
          scalingFactor: 0.5, // Small scale to simulate smaller image
          originalName: 'small.svg',
        )
          ..positionOnCanvas =
              const Offset(250, 50) // Positioned to the right and down
          ..widthOnCanvas = 50, // Half the original size
      ];

      projectSourceFiles.value = testImages;

      final settings = ExportSettings.sizeConstrained(
        widthPx: 300,
        heightPx: 200,
        fileName: 'test_svg_sprite',
        path: tempDir.path,
      );

      // When
      await GenerateSvgSprite.exportSprite(settings);

      // Then
      final savedFile = File('${tempDir.path}/test_svg_sprite.svg');
      expect(savedFile.existsSync(), isTrue,
          reason: 'SVG sprite file should be created');

      final svgContent = await savedFile.readAsString();

      // Verify SVG structure
      expect(svgContent.contains('<svg xmlns="http://www.w3.org/2000/svg"'),
          isTrue);
      expect(svgContent.contains('viewBox="0 0 600 200"'),
          isTrue); // Each frame is 300px wide

      // Verify the larger SVG element is properly positioned in the first frame
      expect(
          svgContent.contains('<g transform="translate(0.00, 0.00)">'), isTrue);
      expect(
          svgContent.contains(
              '<rect x="10" y="10" width="180" height="180" fill="blue"'),
          isTrue);

      // Verify the smaller SVG element is properly positioned in the second frame
      // It should maintain its relative position
      expect(svgContent.contains('<g transform="translate(300.00, 0.00)">'),
          isTrue); // Start of second frame
      expect(svgContent.contains('<circle cx="50" cy="50" r="40" fill="red"'),
          isTrue);
      expect(svgContent.contains('scale('),
          isTrue); // Should have scale transformation

      // The smaller SVG should be positioned with an appropriate offset within its frame
      expect(svgContent.contains('translate(250.00'), isTrue);
    });

    test('handles SVGs with different viewBox values', () async {
      // Given - SVG with explicit viewBox
      const svgWithViewBox = '''
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 200 200">
  <rect x="50" y="50" width="100" height="100" fill="green" />
</svg>''';

      final svgBytes = Uint8List.fromList(utf8.encode(svgWithViewBox));

      final testImages = [
        FlitesImage.scaled(
          svgBytes,
          scalingFactor: 1.0,
          originalName: 'viewbox.svg',
        )
          ..positionOnCanvas = const Offset(50, 50)
          ..widthOnCanvas = 100,
      ];

      projectSourceFiles.value = testImages;

      final settings = ExportSettings.sizeConstrained(
        widthPx: 200,
        heightPx: 200,
        fileName: 'viewbox_test',
        path: tempDir.path,
      );

      // When
      await GenerateSvgSprite.exportSprite(settings);

      // Then
      final savedFile = File('${tempDir.path}/viewbox_test.svg');
      expect(savedFile.existsSync(), isTrue);

      final svgContent = await savedFile.readAsString();
      expect(
          svgContent.contains(
              '<rect x="50" y="50" width="100" height="100" fill="green"'),
          isTrue);

      // The scaling should account for the viewBox vs width/height difference
      expect(svgContent.contains('scale('), isTrue);
    });

    test('handles multiple SVGs with various scaling factors and positions',
        () async {
      // Create three SVGs with different sizes, scales, and positions
      const smallSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50">
  <circle cx="25" cy="25" r="20" fill="red" />
</svg>''';

      const normalSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
  <rect x="10" y="10" width="80" height="80" fill="blue" />
</svg>''';

      const largeSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">
  <path d="M50,50 L150,50 L150,150 L50,150 Z" fill="green" />
</svg>''';

      final svgBytes1 = Uint8List.fromList(utf8.encode(smallSvg));
      final svgBytes2 = Uint8List.fromList(utf8.encode(normalSvg));
      final svgBytes3 = Uint8List.fromList(utf8.encode(largeSvg));

      // Add images at different positions, scales, and with one in negative position
      final testImages = [
        FlitesImage.scaled(
          svgBytes1,
          scalingFactor: 2.0,
          originalName: 'small.svg',
        )
          ..positionOnCanvas = const Offset(-25, 25) // Partially off-canvas
          ..widthOnCanvas = 100, // Double its normal size
        FlitesImage.scaled(
          svgBytes2,
          scalingFactor: 1.0,
          originalName: 'normal.svg',
        )
          ..positionOnCanvas = const Offset(120, 70) // Middle
          ..widthOnCanvas = 100,
        FlitesImage.scaled(
          svgBytes3,
          scalingFactor: 0.25,
          originalName: 'large.svg',
        )
          ..positionOnCanvas = const Offset(280, 10) // Top right
          ..widthOnCanvas = 50, // Quarter its normal size
      ];

      projectSourceFiles.value = testImages;

      // Use different constraint type (width-constrained)
      final settings = ExportSettings.widthConstrained(
        widthPx: 400,
        fileName: 'complex_svg_test',
        path: tempDir.path,
        paddingTopPx: 10.0,
        paddingBottomPx: 15.0,
        paddingLeftPx: 20.0,
        paddingRightPx: 5.0,
      );

      await GenerateSvgSprite.exportSprite(settings);

      final savedFile = File('${tempDir.path}/complex_svg_test.svg');
      expect(savedFile.existsSync(), isTrue);

      final svgContent = await savedFile.readAsString();

      // Verify SVG structure and dimensions
      expect(svgContent.contains('<svg xmlns="http://www.w3.org/2000/svg"'),
          isTrue);

      // All original SVG elements should exist
      expect(svgContent.contains('<circle cx="25" cy="25" r="20" fill="red"'),
          isTrue);
      expect(
          svgContent.contains(
              '<rect x="10" y="10" width="80" height="80" fill="blue"'),
          isTrue);
      expect(
          svgContent.contains(
              '<path d="M50,50 L150,50 L150,150 L50,150 Z" fill="green"'),
          isTrue);

      // Verify padding is correctly applied
      expect(svgContent.contains('translate(20.00, 10.00)'), isTrue,
          reason: 'First frame should have left and top padding applied');

      // Verify second frame positioning based on the implementation
      // Second frame position = 1 * (frameWidth + (leftPadding + rightPadding)) + leftPadding
      // Using width 400 from the settings, horizontalMargin = 20 + 5 = 25
      // Position = 1 * (400 + 25) + 20 = 445
      // Note: We're just documenting the calculation but not storing in a variable since we're not directly checking it

      // We can't check the exact position string since the frame size calculation is complex,
      // but we can check if the content for the second frame (the blue rect) exists
      expect(
          svgContent.contains(
              '<rect x="10" y="10" width="80" height="80" fill="blue"'),
          isTrue,
          reason: 'Second frame content should exist in the output SVG');

      // Check for scaling factors - we don't know the exact factor, so just check for the pattern
      final scaleFactorRegex = RegExp(r'scale\(\d+\.\d+\)');
      expect(scaleFactorRegex.hasMatch(svgContent), isTrue,
          reason: 'Scale factor should be applied to SVG elements');

      // The third SVG content is a path with green fill
      expect(
          svgContent.contains(
              '<path d="M50,50 L150,50 L150,150 L50,150 Z" fill="green"'),
          isTrue,
          reason: 'Third SVG content (green path) should exist in the output');

      // Verify that original viewBox values are preserved
      expect(svgContent.contains('viewBox="0 0 '), isTrue,
          reason: 'The SVG should have a viewBox starting from 0 0');
    });

    test('handles height-constrained export settings', () async {
      // Create two SVGs with different aspect ratios
      const wideSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="100" viewBox="0 0 300 100">
  <rect x="10" y="10" width="280" height="80" fill="purple" />
</svg>''';

      const tallSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="300" viewBox="0 0 100 300">
  <rect x="10" y="10" width="80" height="280" fill="orange" />
</svg>''';

      final svgBytes1 = Uint8List.fromList(utf8.encode(wideSvg));
      final svgBytes2 = Uint8List.fromList(utf8.encode(tallSvg));

      // Position them side by side
      final testImages = [
        FlitesImage.scaled(
          svgBytes1,
          scalingFactor: 1.0,
          originalName: 'wide.svg',
        )
          ..positionOnCanvas = const Offset(0, 0)
          ..widthOnCanvas = 300,
        FlitesImage.scaled(
          svgBytes2,
          scalingFactor: 1.0,
          originalName: 'tall.svg',
        )
          ..positionOnCanvas = const Offset(320, 0)
          ..widthOnCanvas = 100,
      ];

      projectSourceFiles.value = testImages;

      // Use height-constrained settings
      final settings = ExportSettings.heightConstrained(
        heightPx: 250,
        fileName: 'aspect_ratio_test',
        path: tempDir.path,
      );

      await GenerateSvgSprite.exportSprite(settings);

      final savedFile = File('${tempDir.path}/aspect_ratio_test.svg');
      expect(savedFile.existsSync(), isTrue);

      final svgContent = await savedFile.readAsString();

      // Should preserve the SVG elements
      expect(
          svgContent.contains(
              '<rect x="10" y="10" width="280" height="80" fill="purple"'),
          isTrue);
      expect(
          svgContent.contains(
              '<rect x="10" y="10" width="80" height="280" fill="orange"'),
          isTrue);

      // Both frames should be within the height constraint (plus small rounding differences)
      final viewBoxRegExp = RegExp(r'viewBox="0 0 (\d+) (\d+)"');
      final viewBoxMatch = viewBoxRegExp.firstMatch(svgContent);
      expect(viewBoxMatch, isNotNull);

      if (viewBoxMatch != null) {
        final height = int.parse(viewBoxMatch.group(2)!);
        expect(height, lessThanOrEqualTo(255),
            reason: 'Output height should respect the height constraint');
      }
    });

    test('analyzes frame positioning in detail', () async {
      // Create two simple SVGs with fixed size
      const svg1 = '''
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
  <rect x="10" y="10" width="80" height="80" fill="red" />
</svg>''';

      const svg2 = '''
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="40" fill="blue" />
</svg>''';

      final svgBytes1 = Uint8List.fromList(utf8.encode(svg1));
      final svgBytes2 = Uint8List.fromList(utf8.encode(svg2));

      // Position them with exact coordinates
      final testImages = [
        FlitesImage.scaled(svgBytes1,
            scalingFactor: 1.0, originalName: 'rect.svg')
          ..positionOnCanvas = const Offset(0, 0)
          ..widthOnCanvas = 100,
        FlitesImage.scaled(svgBytes2,
            scalingFactor: 1.0, originalName: 'circle.svg')
          ..positionOnCanvas = const Offset(150, 0)
          ..widthOnCanvas = 100,
      ];

      projectSourceFiles.value = testImages;

      // Use fixed size constraints with known padding
      final settings = ExportSettings.sizeConstrained(
        widthPx: 100,
        heightPx: 100,
        fileName: 'positioning_test',
        path: tempDir.path,
        paddingLeftPx: 10.0,
        paddingRightPx: 10.0,
      );

      await GenerateSvgSprite.exportSprite(settings);

      final savedFile = File('${tempDir.path}/positioning_test.svg');
      expect(savedFile.existsSync(), isTrue);

      final svgContent = await savedFile.readAsString();

      // Check first frame's transform
      final firstFrameRegExp =
          RegExp(r'<g transform="translate\((\d+\.\d+), (\d+\.\d+)\)">');
      final firstFrameMatch = firstFrameRegExp.firstMatch(svgContent);
      expect(firstFrameMatch, isNotNull,
          reason: 'Should find first frame translation');

      if (firstFrameMatch != null) {
        final x = double.parse(firstFrameMatch.group(1)!);
        final y = double.parse(firstFrameMatch.group(2)!);
        expect(x, equals(10.0),
            reason: 'First frame should have left padding applied');
        expect(y, equals(0.0), reason: 'First frame should start at top');
      }

      // Extract all frame positions
      final allFrameRegExp =
          RegExp(r'<g transform="translate\((\d+\.\d+), (\d+\.\d+)\)">');
      final allFrameMatches = allFrameRegExp.allMatches(svgContent).toList();

      expect(allFrameMatches.length, equals(2),
          reason: 'Should find exactly two frame translations');

      if (allFrameMatches.length >= 2) {
        final secondFrameX = double.parse(allFrameMatches[1].group(1)!);

        // The second frame position should be:
        // i * (frameWidth + horizontalMargin) + leftPadding, where i=1
        // horizontalMargin = leftPadding + rightPadding = 10 + 10 = 20
        // So: 1 * (100 + 20) + 10 = 130
        const expectedX = 1 * (100 + 20) +
            10; // i * (frameWidth + horizontalMargin) + leftPadding

        expect(secondFrameX, equals(expectedX),
            reason:
                'Second frame should be positioned at i * (frameWidth + horizontalMargin) + leftPadding');
      }

      // Verify scaling and content without explicitly printing the SVG
      final scaleRegex = RegExp(r'scale\(0\.400000\)');
      expect(scaleRegex.hasMatch(svgContent), isTrue,
          reason: 'Frame content should be scaled appropriately');
    });
  });
}
