import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flutter/material.dart';

BoundingBox? get allImagesBoundingBox {
  return boundingBoxOfRow(selectedImageRow.value);
}

BoundingBox? boundingBoxOfRow(int rowIndex) {
  final allImages = projectSourceFiles.value.rows[rowIndex].images;

  if (allImages.isEmpty) {
    return null;
  }

  final topMost = allImages.map((e) => e.positionOnCanvas.dy).fold(
      double.infinity, (value, element) => value < element ? value : element);

  final leftMost = allImages.map((e) => e.positionOnCanvas.dx).fold(
      double.infinity, (value, element) => value < element ? value : element);

  final bottomMost = allImages
      .map((e) => e.positionOnCanvas.dy + e.heightOnCanvas)
      .fold(0.0, (value, element) => value > element ? value : element);

  final rightMost = allImages
      .map((e) => e.positionOnCanvas.dx + e.widthOnCanvas)
      .fold(0.0, (value, element) => value > element ? value : element);

  return BoundingBox(
    position: Offset(leftMost, topMost),
    size: Size(rightMost - leftMost, bottomMost - topMost),
  );
}

class BoundingBox {
  final Offset position;
  final Size size;

  BoundingBox({
    required this.position,
    required this.size,
  });

  Size get normalizedSize {
    // Normalize side such that the longer side is 1.0
    final widthIsLonger = size.width > size.height;

    if (widthIsLonger) {
      return Size(1.0, size.height / size.width);
    } else {
      return Size(size.width / size.height, 1.0);
    }
  }
}
