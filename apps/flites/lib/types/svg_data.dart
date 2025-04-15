import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flites/utils/svg_utils.dart';

class SvgData {
  final Size sizeFromHeightAndWidth;
  final Rect viewBox;
  final Offset center;
  final String content;
  final String attributes;
  final Uint8List svgData;
  final String svgString;

  SvgData({
    required this.sizeFromHeightAndWidth,
    required this.viewBox,
    required this.center,
    required this.content,
    required this.attributes,
    required this.svgData,
    required this.svgString,
  });

  factory SvgData.fromSvgString(String svgString) {
    final svgData = Uint8List.fromList(utf8.encode(svgString));
    return SvgData.fromSvgData(svgData);
  }

  factory SvgData.fromSvgData(Uint8List svgData) {
    final svgString = String.fromCharCodes(svgData);

    // Get all relevant data from the original svg
    final sizeFromHeightAndWidth = SvgUtils.getSvgSize(svgData);
    final viewBox =
        SvgUtils.getViewBox(svgData) ?? const Rect.fromLTRB(0, 0, 100, 100);
    final center = SvgUtils.getCenterOfRect(viewBox);

    final content = SvgUtils.getContent(svgString);
    final attributes = SvgUtils.getAttributes(svgString);

    return SvgData(
      sizeFromHeightAndWidth: sizeFromHeightAndWidth,
      viewBox: viewBox,
      center: center,
      content: content,
      attributes: attributes,
      svgData: svgData,
      svgString: svgString,
    );
  }
}
