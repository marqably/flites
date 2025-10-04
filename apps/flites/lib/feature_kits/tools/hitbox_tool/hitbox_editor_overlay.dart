import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main.dart';

class HitboxEditorOverlay extends StatefulWidget {
  const HitboxEditorOverlay({
    required this.child,
    required this.onHitboxPointsChanged,
    required this.initialHitboxPoints,
    required this.boundingBox,
    super.key,
  });
  final Widget child;
  final Function(List<Offset>) onHitboxPointsChanged;
  final List<Offset> initialHitboxPoints;
  final Rect boundingBox;

  @override
  State<HitboxEditorOverlay> createState() => _HitboxEditorOverlayState();
}

class _HitboxEditorOverlayState extends State<HitboxEditorOverlay> {
  List<Offset> hitboxPoints = [];
  int? selectedPointIndex;
  bool isDragging = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..requestFocus();

    hitboxPoints = widget.initialHitboxPoints;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Offset clampToBoundingBox(Offset point) => Offset(
        point.dx.clamp(0, 1),
        point.dy.clamp(0, 1),
      );

  // Add a point when tapping on empty space
  void _addPoint(Offset position) {
    setState(() {
      if (hitboxPoints.isEmpty) {
        // First point
        hitboxPoints.add(position);
        selectedPointIndex = 0;
      } else if (hitboxPoints.length == 1) {
        // Second point - just add it
        hitboxPoints.add(position);
        selectedPointIndex = 1;
      } else {
        // Find the edge (line between consecutive points) closest to the new point
        double minDistance = double.infinity;
        int insertIndex = 0;

        // Check distance to each edge (including the edge from last to first point)
        for (int i = 0; i < hitboxPoints.length; i++) {
          final int nextIdx = (i + 1) % hitboxPoints.length;

          // Calculate distance from point to line segment
          final double distance = _distanceToLineSegment(
            hitboxPoints[i],
            hitboxPoints[nextIdx],
            position,
          );

          if (distance < minDistance) {
            minDistance = distance;
            insertIndex = nextIdx; // Insert before the next point
          }
        }

        // Insert the new point at the determined position
        hitboxPoints.insert(insertIndex, position);
        selectedPointIndex = insertIndex;
      }

      widget.onHitboxPointsChanged(hitboxPoints);
    });
  }

  Offset localToRelativePosition(Offset localPosition) {
    final posWithoutOffset = localPosition - widget.boundingBox.topLeft;

    final position = Offset(
      posWithoutOffset.dx / widget.boundingBox.width,
      posWithoutOffset.dy / widget.boundingBox.height,
    );

    return clampToBoundingBox(position);
  }

  Offset relativeToLocalPosition(Offset relativePosition) =>
      Offset(
        relativePosition.dx * widget.boundingBox.width,
        relativePosition.dy * widget.boundingBox.height,
      ) +
      widget.boundingBox.topLeft;

  // Calculate the distance from a point to a line segment
  double _distanceToLineSegment(Offset start, Offset end, Offset point) {
    // Vector from start to end
    final double segmentLengthX = end.dx - start.dx;
    final double segmentLengthY = end.dy - start.dy;

    // If the segment is actually a point
    if (segmentLengthX == 0 && segmentLengthY == 0) {
      return (point - start).distance;
    }

    // Project point onto the line and find the parameter t
    final double t = ((point.dx - start.dx) * segmentLengthX +
            (point.dy - start.dy) * segmentLengthY) /
        (segmentLengthX * segmentLengthX + segmentLengthY * segmentLengthY);

    // Clamp t to the segment
    final double clampedT = t.clamp(0.0, 1.0);

    // Find the closest point on the segment
    final Offset closestPoint = Offset(
      start.dx + clampedT * segmentLengthX,
      start.dy + clampedT * segmentLengthY,
    );

    // Return the distance to the closest point
    return (point - closestPoint).distance;
  }

  // Find if a point was tapped (with some tolerance for easier selection)
  int? _findPointAtPosition(Offset position) {
    const double tapTolerance = 0.02; // Radius around point that can be tapped

    for (int i = 0; i < hitboxPoints.length; i++) {
      if ((hitboxPoints[i] - position).distance <= tapTolerance) {
        return i;
      }
    }
    return null;
  }

  // Move the selected point to a new position
  void _moveSelectedPoint(Offset newPosition) {
    if (selectedPointIndex != null) {
      setState(() {
        hitboxPoints[selectedPointIndex!] = newPosition;
        widget.onHitboxPointsChanged(hitboxPoints);
      });
    }
  }

  // Delete the selected point
  void _deleteSelectedPoint() {
    if (selectedPointIndex != null) {
      setState(() {
        hitboxPoints.removeAt(selectedPointIndex!);
        selectedPointIndex = null;
        widget.onHitboxPointsChanged(hitboxPoints);
      });
    }
  }

  // Handle key events (like Delete key)
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if ((event.logicalKey == LogicalKeyboardKey.delete ||
              event.logicalKey == LogicalKeyboardKey.backspace) &&
          selectedPointIndex != null) {
        _deleteSelectedPoint();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final points = hitboxPoints.map(relativeToLocalPosition).toList();

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) {
                final relativePosition =
                    localToRelativePosition(details.localPosition);

                final tappedPointIndex = _findPointAtPosition(relativePosition);

                setState(() {
                  if (tappedPointIndex != null) {
                    // If tapped on a point, select it
                    selectedPointIndex = tappedPointIndex;
                  } else {
                    // If tapped on empty space, add a new point
                    _addPoint(relativePosition);
                  }
                });
              },
              onPanStart: (details) {
                final relativePosition =
                    localToRelativePosition(details.localPosition);

                final pointIndex = _findPointAtPosition(relativePosition);
                if (pointIndex != null) {
                  setState(() {
                    selectedPointIndex = pointIndex;
                    isDragging = true;
                  });
                }
              },
              onPanUpdate: (details) {
                final relativePosition =
                    localToRelativePosition(details.localPosition);

                if (isDragging && selectedPointIndex != null) {
                  _moveSelectedPoint(relativePosition);
                }
              },
              onPanEnd: (_) {
                setState(() {
                  isDragging = false;
                });
              },
              child: CustomPaint(
                painter: HitboxPainter(
                  points: points,
                  selectedPointIndex: selectedPointIndex,
                  primaryColor: context.colors.primary,
                  secondaryColor: context.colors.secondary,
                ),
              ),
            ),
          ),
          // Delete button appears when a point is selected
          if (selectedPointIndex != null)
            Positioned(
              top: 10,
              right: 10,
              child: ElevatedButton.icon(
                onPressed: _deleteSelectedPoint,
                icon: const Icon(Icons.delete),
                label: const Text('Delete Point'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HitboxPainter extends CustomPainter {
  HitboxPainter({
    required this.points,
    required this.primaryColor,
    required this.secondaryColor,
    this.selectedPointIndex,
  });
  final List<Offset> points;
  final int? selectedPointIndex;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    // Draw the filled area with 10% opacity
    if (points.length >= 3) {
      final Path path = Path()..addPolygon(points, true);
      final Paint fillPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Draw the boundary lines
    if (points.length >= 2) {
      final Paint linePaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final Path path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      if (points.length > 2) {
        path.close(); // Close the path to connect the last point to the first
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw all points in yellow
    final Paint pointPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      // Draw selected point larger and with a different color
      if (i == selectedPointIndex) {
        canvas
          ..drawCircle(points[i], 8, Paint()..color = secondaryColor)
          ..drawCircle(points[i], 6, pointPaint);
      } else {
        canvas.drawCircle(points[i], 5, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HitboxPainter oldDelegate) =>
      !listEquals(oldDelegate.points, points) ||
      oldDelegate.selectedPointIndex != selectedPointIndex;
}
