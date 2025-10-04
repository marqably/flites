import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flites/utils/image_utils.dart';

void main() {
  group('SVG Processing Integration', () {
    // Sample SVG data for testing
    final validSvg = Uint8List.fromList(utf8.encode('''
      <svg xmlns="http://www.w3.org/2000/svg" width="200" height="150">
        <rect width="100" height="100" fill="blue" />
      </svg>
    '''));

    final invalidData =
        Uint8List.fromList(utf8.encode('<div>Not an SVG</div>'));

    group('SVG Validation', () {
      test('SvgUtils.isSvg should correctly identify SVG data', () {
        expect(SvgUtils.isSvg(validSvg), isTrue);
        expect(SvgUtils.isSvg(invalidData), isFalse);
      });
    });

    group('SVG Dimension Extraction', () {
      test('SvgUtils.getSvgSize should extract correct dimensions from SVG',
          () {
        expect(SvgUtils.getSvgSize(validSvg).width, equals(200));
        expect(SvgUtils.getSvgSize(validSvg).height, equals(150));
      });
    });

    group('ImageUtils Integration', () {
      test('ImageUtils.sizeOfRawImage should handle SVG files', () {
        // Test that ImageUtils correctly delegates to SvgUtils for SVG files
        expect(ImageUtils.sizeOfRawImage(validSvg).width, equals(200));
        expect(ImageUtils.sizeOfRawImage(validSvg).height, equals(150));
      });
    });
  });
}
