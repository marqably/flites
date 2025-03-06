import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flites/utils/svg_utils.dart';

void main() {
  group('SvgUtils', () {
    group('SVG Validation', () {
      test('isSvg should correctly identify SVG data', () {
        // Test data
        final validSvg = Uint8List.fromList(utf8.encode('''
          <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
            <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
          </svg>
        '''));

        final validSvgSingleQuotes = Uint8List.fromList(utf8.encode('''
          <svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'>
            <circle cx='50' cy='50' r='40' stroke='black' stroke-width='3' fill='red' />
          </svg>
        '''));

        final validSvgNoNamespace = Uint8List.fromList(utf8.encode('''
          <svg width="100" height="100">
            <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
          </svg>
        '''));

        final invalidData =
            Uint8List.fromList(utf8.encode('<div>Not an SVG</div>'));
        final emptyData = Uint8List.fromList([]);

        // Assertions
        expect(SvgUtils.isSvg(validSvg), isTrue,
            reason: 'Standard SVG should be recognized');
        expect(SvgUtils.isSvg(validSvgSingleQuotes), isTrue,
            reason: 'SVG with single quotes should be recognized');
        expect(SvgUtils.isSvg(validSvgNoNamespace), isTrue,
            reason: 'SVG without namespace should be recognized');
        expect(SvgUtils.isSvg(invalidData), isFalse,
            reason: 'Non-SVG data should be rejected');
        expect(SvgUtils.isSvg(emptyData), isFalse,
            reason: 'Empty data should be rejected');
      });
    });

    group('SVG Dimension Extraction', () {
      test('getSvgSize should extract correct dimensions from SVG', () {
        // Test data
        final svgWithDimensions = Uint8List.fromList(utf8.encode('''
          <svg xmlns="http://www.w3.org/2000/svg" width="200" height="150">
            <rect width="100" height="100" fill="blue" />
          </svg>
        '''));

        final svgWithUnits = Uint8List.fromList(utf8.encode('''
          <svg xmlns="http://www.w3.org/2000/svg" width="200px" height="150px">
            <rect width="100" height="100" fill="blue" />
          </svg>
        '''));

        final svgWithViewBox = Uint8List.fromList(utf8.encode('''
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 200">
            <rect width="100" height="100" fill="blue" />
          </svg>
        '''));

        final svgNoDimensions = Uint8List.fromList(utf8.encode('''
          <svg xmlns="http://www.w3.org/2000/svg">
            <rect width="100" height="100" fill="blue" />
          </svg>
        '''));

        // Assertions
        expect(SvgUtils.getSvgSize(svgWithDimensions),
            equals(const Size(200, 150)),
            reason: 'Should extract explicit dimensions');

        expect(SvgUtils.getSvgSize(svgWithUnits), equals(const Size(200, 150)),
            reason: 'Should handle dimensions with units');

        // Note: Our implementation currently doesn't extract viewBox dimensions
        // This is a known limitation that could be improved in the future
        expect(
            SvgUtils.getSvgSize(svgWithViewBox), equals(const Size(100, 100)),
            reason: 'Should use default size for viewBox-only SVGs');

        expect(
            SvgUtils.getSvgSize(svgNoDimensions), equals(const Size(100, 100)),
            reason: 'Should use default size for SVGs without dimensions');
      });
    });
  });
}
