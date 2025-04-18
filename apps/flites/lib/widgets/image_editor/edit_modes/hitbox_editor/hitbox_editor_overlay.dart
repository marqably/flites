import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HitboxEditorOverlay extends StatefulWidget {
  final Widget child;
  final Function(List<Offset>) onHitboxPointsChanged;

  const HitboxEditorOverlay({
    super.key,
    required this.child,
    required this.onHitboxPointsChanged,
  });

  @override
  State<HitboxEditorOverlay> createState() => _HitboxEditorOverlayState();
}

class _HitboxEditorOverlayState extends State<HitboxEditorOverlay> {
  List<Offset> hitboxPoints = [];
  int? selectedPointIndex;
  bool isDragging = false;

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
          int nextIdx = (i + 1) % hitboxPoints.length;

          // Calculate distance from point to line segment
          double distance = _distanceToLineSegment(
              hitboxPoints[i], hitboxPoints[nextIdx], position);

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
    final Offset closestPoint = Offset(start.dx + clampedT * segmentLengthX,
        start.dy + clampedT * segmentLengthY);

    // Return the distance to the closest point
    return (point - closestPoint).distance;
  }

  // Find if a point was tapped (with some tolerance for easier selection)
  int? _findPointAtPosition(Offset position) {
    const double tapTolerance = 20.0; // Radius around point that can be tapped

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
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (TapDownDetails details) {
                final tappedPointIndex =
                    _findPointAtPosition(details.localPosition);

                setState(() {
                  if (tappedPointIndex != null) {
                    // If tapped on a point, select it
                    selectedPointIndex = tappedPointIndex;
                  } else {
                    // If tapped on empty space, add a new point
                    _addPoint(details.localPosition);
                  }
                });
              },
              onPanStart: (DragStartDetails details) {
                final pointIndex = _findPointAtPosition(details.localPosition);
                if (pointIndex != null) {
                  setState(() {
                    selectedPointIndex = pointIndex;
                    isDragging = true;
                  });
                }
              },
              onPanUpdate: (DragUpdateDetails details) {
                if (isDragging && selectedPointIndex != null) {
                  _moveSelectedPoint(details.localPosition);
                }
              },
              onPanEnd: (_) {
                setState(() {
                  isDragging = false;
                });
              },
              child: CustomPaint(
                painter: HitboxPainter(
                  points: hitboxPoints,
                  selectedPointIndex: selectedPointIndex,
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
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HitboxPainter extends CustomPainter {
  final List<Offset> points;
  final int? selectedPointIndex;

  HitboxPainter({
    required this.points,
    this.selectedPointIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Draw the filled area with 10% opacity red
    if (points.length >= 3) {
      final Path path = Path()..addPolygon(points, true);
      final Paint fillPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Draw the boundary lines
    if (points.length >= 2) {
      final Paint linePaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final Path path = Path();
      path.moveTo(points.first.dx, points.first.dy);
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
      ..color = Colors.yellow
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      // Draw selected point larger and with a different color
      if (i == selectedPointIndex) {
        canvas.drawCircle(points[i], 8.0, Paint()..color = Colors.green);
        canvas.drawCircle(points[i], 6.0, pointPaint);
      } else {
        canvas.drawCircle(points[i], 5.0, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HitboxPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.selectedPointIndex != selectedPointIndex;
  }
}
