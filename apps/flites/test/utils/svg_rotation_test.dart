import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flites/utils/svg_utils.dart';
import 'package:flutter_test/flutter_test.dart';

String createTestSvg({double width = 200, double height = 100}) =>
    '<svg width="$width" height="$height" '
    'viewBox="0 0 $width $height" '
    'xmlns="http://www.w3.org/2000/svg">'
    '<rect x="10" y="10" width="80" height="60" fill="red"/></svg>';

Uint8List svgToBytes(String svg) => Uint8List.fromList(utf8.encode(svg));

void main() {
  group('SvgUtils', () {
    group('isSvg', () {
      test('returns true for valid SVG data', () {
        final svgBytes = svgToBytes(createTestSvg());
        expect(SvgUtils.isSvg(svgBytes), isTrue);
      });

      test('returns false for non-SVG data', () {
        final pngBytes =
            Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]);
        expect(SvgUtils.isSvg(pngBytes), isFalse);
      });

      test('returns false for data shorter than 5 bytes', () {
        final shortData = Uint8List.fromList([1, 2, 3]);
        expect(SvgUtils.isSvg(shortData), isFalse);
      });
    });

    group('getSvgSize', () {
      test('extracts explicit width and height', () {
        final svgBytes = svgToBytes(createTestSvg(width: 300, height: 150));
        final size = SvgUtils.getSvgSize(svgBytes);
        expect(size, const Size(300, 150));
      });

      test('falls back to viewBox when no explicit dimensions', () {
        final svgBytes = svgToBytes(
          '<svg viewBox="0 0 400 200" xmlns="http://www.w3.org/2000/svg">'
          ' <rect/></svg>',
        );
        final size = SvgUtils.getSvgSize(svgBytes);
        expect(size, const Size(400, 200));
      });

      test('returns default 100x100 for SVG without dimensions', () {
        final svgBytes = svgToBytes(
          '<svg xmlns="http://www.w3.org/2000/svg"><rect/></svg>',
        );
        final size = SvgUtils.getSvgSize(svgBytes);
        expect(size, const Size(100, 100));
      });
    });

    group('getViewBox', () {
      test('extracts viewBox as Rect', () {
        final svgBytes = svgToBytes(createTestSvg());
        final viewBox = SvgUtils.getViewBox(svgBytes);
        expect(viewBox, isNotNull);
        expect(viewBox!.left, 0);
        expect(viewBox.top, 0);
        expect(viewBox.width, 200);
        expect(viewBox.height, 100);
      });

      test('handles viewBox with offset', () {
        final svgBytes = svgToBytes(
          '<svg viewBox="10 20 300 150" '
          'xmlns="http://www.w3.org/2000/svg"><rect/></svg>',
        );
        final viewBox = SvgUtils.getViewBox(svgBytes);
        expect(viewBox, isNotNull);
        expect(viewBox!.left, 10);
        expect(viewBox.top, 20);
        expect(viewBox.width, 300);
        expect(viewBox.height, 150);
      });
    });

    group('getContent', () {
      test('extracts inner content of SVG', () {
        const svg =
            '<svg width="100" height="100"><rect x="0" y="0"/></svg>';
        final content = SvgUtils.getContent(svg);
        expect(content, contains('<rect'));
      });
    });

    group('getAttributes', () {
      test('extracts attributes from svg tag', () {
        const svg = '<svg width="100" height="200" viewBox="0 0 100 200">'
            ' <rect/></svg>';
        final attrs = SvgUtils.getAttributes(svg);
        expect(attrs, contains('width="100"'));
        expect(attrs, contains('height="200"'));
        expect(attrs, contains('viewBox="0 0 100 200"'));
      });
    });

    group('rotateBox', () {
      test('90 degree rotation swaps dimensions', () {
        final rotated = SvgUtils.rotateBox(const Size(200, 100), pi / 2);
        expect(rotated.width, closeTo(100, 1));
        expect(rotated.height, closeTo(200, 1));
      });

      test('45 degree rotation produces larger bounding box', () {
        const original = Size(200, 100);
        final rotated = SvgUtils.rotateBox(original, pi / 4);
        expect(rotated.width, greaterThan(original.width));
        expect(rotated.height, greaterThan(original.height));
      });
    });

    group('updateSvgViewBox', () {
      test('replaces existing viewBox', () {
        const attrs = ' width="100" height="100" viewBox="0 0 100 100"';
        final updated = SvgUtils.updateSvgViewBox(
          attrs,
          width: 200,
          height: 150,
          x: 10,
          y: 20,
        );
        expect(updated, contains('viewBox="10 20 200 150"'));
        expect(updated, isNot(contains('viewBox="0 0 100 100"')));
      });

      test('adds viewBox when missing', () {
        const attrs = ' width="100" height="100"';
        final updated = SvgUtils.updateSvgViewBox(
          attrs,
          width: 200,
          height: 150,
          x: 0,
          y: 0,
        );
        expect(updated, contains('viewBox="0 0 200 150"'));
      });
    });

    group('updateSvgSize', () {
      test('replaces existing width and height', () {
        const attrs = ' width="100" height="100"';
        final updated = SvgUtils.updateSvgSize(attrs, 200, 150);
        expect(updated, contains('width="200"'));
        expect(updated, contains('height="150"'));
      });

      test('adds width and height when missing', () {
        const attrs = ' viewBox="0 0 100 100"';
        final updated = SvgUtils.updateSvgSize(attrs, 200, 150);
        expect(updated, contains('width="200"'));
        expect(updated, contains('height="150"'));
      });
    });

    group('svgStringFromParts', () {
      test('builds valid SVG with wrapper', () {
        final svg = SvgUtils.svgStringFromParts(
          attributes: ' width="100" height="100"',
          contentWrapper: '<g transform="rotate(45, 50, 50)">',
          contentWrapperClosingTag: '</g>',
          content: '<rect x="0" y="0" width="50" height="50"/>',
        );
        expect(svg, contains('<svg'));
        expect(svg, contains('</svg>'));
        expect(svg, contains('rotate(45, 50, 50)'));
        expect(svg, contains('<rect'));
      });

      test('builds SVG without wrapper', () {
        final svg = SvgUtils.svgStringFromParts(
          attributes: ' width="100"',
          content: '<circle r="10"/>',
        );
        expect(svg, contains('<svg'));
        expect(svg, contains('<circle'));
        expect(svg, isNot(contains('<g')));
      });
    });

    group('getDataAttribute', () {
      test('extracts numeric data attribute', () {
        const attrs = ' width="100" data-orig-w="200.5" height="50"';
        final value = SvgUtils.getDataAttribute(attrs, 'data-orig-w');
        expect(value, 200.5);
      });

      test('returns null when attribute missing', () {
        const attrs = ' width="100" height="50"';
        final value = SvgUtils.getDataAttribute(attrs, 'data-orig-w');
        expect(value, isNull);
      });
    });

    group('ensureOriginalSizeAttributes', () {
      test('adds data-orig attributes when missing', () {
        const attrs = ' width="200" height="100"';
        final result = SvgUtils.ensureOriginalSizeAttributes(
          attrs,
          const Size(200, 100),
          const Offset(100, 50),
        );
        expect(result, contains('data-orig-w="200.0"'));
        expect(result, contains('data-orig-h="100.0"'));
        expect(result, contains('data-orig-cx="100.0"'));
        expect(result, contains('data-orig-cy="50.0"'));
      });

      test('does not duplicate when already present', () {
        const attrs =
            ' width="200" data-orig-w="200.0" data-orig-h="100.0"';
        final result = SvgUtils.ensureOriginalSizeAttributes(
          attrs,
          const Size(200, 100),
          const Offset(100, 50),
        );
        expect(result, attrs);
      });
    });

    group('extractExistingRotationDegrees', () {
      test('extracts angle from rotation transform', () {
        const content =
            '<g transform="rotate(45, 100, 50)"><rect/></g>';
        final degrees =
            SvgUtils.extractExistingRotationDegrees(content);
        expect(degrees, 45);
      });

      test('returns 0 when no rotation transform', () {
        const content = '<rect x="0" y="0"/>';
        final degrees =
            SvgUtils.extractExistingRotationDegrees(content);
        expect(degrees, 0);
      });

      test('handles decimal angles', () {
        const content =
            '<g transform="rotate(33.5, 100, 50)"><rect/></g>';
        final degrees =
            SvgUtils.extractExistingRotationDegrees(content);
        expect(degrees, 33.5);
      });
    });

    group('stripRotationWrapper', () {
      test('removes outermost rotation g element', () {
        const content =
            '<g transform="rotate(45, 100, 50)"><rect x="0" y="0"/></g>';
        final stripped = SvgUtils.stripRotationWrapper(content);
        expect(stripped, contains('<rect'));
        expect(stripped, isNot(contains('rotate(')));
      });

      test('returns content unchanged when no rotation wrapper', () {
        const content = '<rect x="0" y="0"/>';
        final stripped = SvgUtils.stripRotationWrapper(content);
        expect(stripped, content);
      });

      test('preserves nested g elements', () {
        const content = '<g transform="rotate(45, 100, 50)">'
            ' <g id="inner"><rect/></g></g>';
        final stripped = SvgUtils.stripRotationWrapper(content);
        expect(stripped, contains('<g id="inner">'));
        expect(stripped, contains('<rect/>'));
      });
    });

    group('rotateAndTrimSvg', () {
      test('produces valid SVG with rotation transform', () async {
        final svgBytes = svgToBytes(createTestSvg());
        final rotated = await SvgUtils.rotateAndTrimSvg(svgBytes, pi / 4);
        final rotatedStr = String.fromCharCodes(rotated);

        expect(rotatedStr, contains('<svg'));
        expect(rotatedStr, contains('</svg>'));
        expect(rotatedStr, contains('rotate('));
      });

      test('adds data-orig attributes on first rotation', () async {
        final svgBytes = svgToBytes(createTestSvg());
        final rotated = await SvgUtils.rotateAndTrimSvg(svgBytes, pi / 6);
        final rotatedStr = String.fromCharCodes(rotated);

        expect(rotatedStr, contains('data-orig-w="200.0"'));
        expect(rotatedStr, contains('data-orig-h="100.0"'));
        expect(rotatedStr, contains('data-orig-cx='));
        expect(rotatedStr, contains('data-orig-cy='));
      });

      test('returns unchanged SVG for near-zero angle', () async {
        final svgBytes = svgToBytes(createTestSvg());
        final rotated =
            await SvgUtils.rotateAndTrimSvg(svgBytes, 0.0001);
        expect(rotated, equals(svgBytes));
      });

      test('composes multiple rotations into single transform',
          () async {
        final svgBytes = svgToBytes(createTestSvg());

        // First rotation: 30 degrees
        final rotated1 =
            await SvgUtils.rotateAndTrimSvg(svgBytes, pi / 6);
        // Second rotation: another 30 degrees
        final rotated2 =
            await SvgUtils.rotateAndTrimSvg(rotated1, pi / 6);

        final resultStr = String.fromCharCodes(rotated2);

        // Should have a single rotation transform of ~60 degrees
        final rotateMatches =
            RegExp(r'rotate\(').allMatches(resultStr);
        expect(
          rotateMatches.length,
          1,
          reason: 'Should have exactly one rotate transform',
        );

        // The angle should be ~60 degrees
        final angleMatch =
            RegExp(r'rotate\(\s*([0-9.]+)').firstMatch(resultStr);
        expect(angleMatch, isNotNull);
        final angle = double.parse(angleMatch!.group(1)!);
        expect(angle, closeTo(60, 1));
      });

      test(
        'bounding box does not grow with repeated same-angle rotations',
        () async {
          final svgBytes = svgToBytes(createTestSvg());

          // Rotate 45 degrees
          final rotated1 =
              await SvgUtils.rotateAndTrimSvg(svgBytes, pi / 4);

          // Rotate back -45 degrees (should return to roughly original size)
          final rotated2 =
              await SvgUtils.rotateAndTrimSvg(rotated1, -pi / 4);
          final size2 = SvgUtils.getSvgSize(rotated2);

          // Rotating back should produce dimensions close to original
          // Allow some rounding because we use .ceil()
          expect(size2.width, closeTo(200, 2));
          expect(size2.height, closeTo(100, 2));
        },
      );

      test('preserves data-orig attributes through multiple rotations',
          () async {
        final svgBytes = svgToBytes(createTestSvg());
        final rotated1 =
            await SvgUtils.rotateAndTrimSvg(svgBytes, pi / 6);
        final rotated2 =
            await SvgUtils.rotateAndTrimSvg(rotated1, pi / 6);
        final rotated3 =
            await SvgUtils.rotateAndTrimSvg(rotated2, pi / 6);

        final resultStr = String.fromCharCodes(rotated3);

        // Original dimensions should still be 200x100
        expect(resultStr, contains('data-orig-w="200.0"'));
        expect(resultStr, contains('data-orig-h="100.0"'));
      });

      test('viewBox adjusts for rotated bounding box', () async {
        final svgBytes = svgToBytes(createTestSvg());
        final rotated =
            await SvgUtils.rotateAndTrimSvg(svgBytes, pi / 4);
        final viewBox = SvgUtils.getViewBox(rotated)!;

        // 45° rotation of 200x100 → bounding box should be larger
        expect(viewBox.width, greaterThan(200));
        expect(viewBox.height, greaterThan(100));
      });
    });
  });
}
