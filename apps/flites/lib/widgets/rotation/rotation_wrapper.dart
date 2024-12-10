import 'dart:math';
import 'package:flutter/material.dart';

class RotationWrapper extends StatefulWidget {
  const RotationWrapper({
    super.key,
    required this.child,
    required this.rect,
  });

  final Widget child;
  final Rect rect;

  @override
  State<RotationWrapper> createState() => _RotationWrapperState();
}

class _RotationWrapperState extends State<RotationWrapper> {
  double rotation =
      0.0; // Accumulated rotation angle (needed so it does not flip)
  // Offset _center = Offset.zero;
  Offset dragStartPoint = Offset.zero;

  late final double circleRadius;

  @override
  void initState() {
    super.initState();
    // _center = widget.rect.center;
    circleRadius = (longestSideSize(widget.rect.size) / 2) * 1.5;
    dragStartPoint = Offset(0, circleRadius);

    print('Original drag start point: $dragStartPoint');
  }

  double calculateAngle(Offset start, Offset end) {
    double startAngle = atan2(start.dy, start.dx);
    double endAngle = atan2(end.dy, end.dx);

    // Find the difference in angles, normalized to be within [-pi, pi]
    double angleDifference = endAngle - startAngle;

    // print(
    //     'Angle between start ( $start ) and end ( $end ) is: $angleDifference')t;
    return angleDifference;
  }

  void _updateRotation(Offset currentPosition) {
    final newAngle =
        calculateAngle(Offset(0, 1), dragStartPoint + flipY(currentPosition));
    // print('From position: $dragStartPoint');
    // print('To position: ${dragStartPoint + flipY(currentPosition)}');
    // print('Angular Change in degrees: ${newAngle * 180 / pi}');
    // print('New rotation: ${dragStartPoint.direction - newAngle - pi / 2}');

    print('Current angle: ${rotation * 180 / pi}');

    setState(() {
      rotation = -newAngle;
    });
  }

  void updateStartPoint(Offset endPosition) {
    // final currentStartPosition = dragStartPoint;
    final endAngle =
        calculateAngle(dragStartPoint, dragStartPoint + flipY(endPosition));
    final oldPoint = dragStartPoint;

    final angleInDegrees = endAngle * 180 / pi;
    dragStartPoint = rotateOffset(dragStartPoint, endAngle);

    // final bestNewStartPoint = scaleOffset(
    //     dragStartPoint + flipY(endPosition), widget.rect.height / 2);

    // final rotatedOffset = rotateOffset(dragStartPoint, endAngle);

    final newPoint = dragStartPoint;
    print('hi');
    print('new start point: $newPoint');
    setState(() {});
//
    // final standardizedEndPosition = standardizeOffsetToRotation(endPosition);

    // final endPoint = pointFromAngleAndLength(endAngle, widget.rect.height / 2);

    // /// No need to call setState as this is only needed for calculations
    // dragStartPoint = endPoint;
    // final angle = -(dragStartPoint.direction - pi / 2);
    // print('Angle in degrees: ${angle * 180 / pi}');
    // print('Start Drag Point: $dragStartPoint');
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.rect.height * 0.1;

    return Transform.rotate(
      origin: Offset(0, 0),
      angle: rotation,
      child: Container(
        height: circleRadius * 2,
        width: circleRadius * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.rect.width,
                maxHeight: widget.rect.height,
              ),
              child: widget.child,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: const Color.fromARGB(255, 102, 102, 102),
                  width: 2,
                ),
                // color: const Color.fromARGB(255, 117, 174, 255),
              ),
              // height: longestSideSize(widget.rect.size),
              width: circleRadius * 2 - (dotSize * 2 / 3),
            ),
            Positioned(
              top: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.precise,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) {
                    // Initialize the start vector
                  },
                  onPanUpdate: (details) {
                    // Update the rotation based on the current position
                    _updateRotation(
                        standardizeOffsetToRotation(details.localPosition));
                  },
                  onPanEnd: (details) {
                    updateStartPoint(
                        standardizeOffsetToRotation(details.localPosition));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 31, 31, 31),
                    ),
                    height: dotSize,
                    width: dotSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Offset standardizeOffsetToRotation(Offset offset) {
    final angle = -(dragStartPoint.direction - pi / 2);
    // print('Angle in degrees: ${angle * 180 / pi}');

    double x = offset.dx * cos(angle) - offset.dy * sin(angle);
    double y = offset.dx * sin(angle) + offset.dy * cos(angle);
    return Offset(x, y);
  }
}

double longestSide(Offset offset) {
  return offset.dx.abs() > offset.dy.abs() ? offset.dx.abs() : offset.dy.abs();
}

double longestSideSize(Size size) {
  return size.width > size.height ? size.width : size.height;
}

Offset pointFromAngleAndLength(double angle, double length) {
  double adjustedAngle = angle - pi / 2;
  double x = length * cos(adjustedAngle);
  double y = length * sin(adjustedAngle);
  return flipY(Offset(x, y));
}

Offset flipY(Offset offset) {
  return Offset(offset.dx, -offset.dy);
}

Offset rotateOffset(Offset offset, double angle) {
  return Offset(
    offset.dx * cos(angle) - offset.dy * sin(angle),
    offset.dx * sin(angle) + offset.dy * cos(angle),
  );
}

Offset scaleOffset(Offset offset, double length) {
  double currentLength = offset.distance; // Magnitude of the vector
  if (currentLength == 0) {
    return Offset.zero; // Avoid division by zero for a zero-length vector
  }
  double scale = length / currentLength;
  return Offset(offset.dx * scale, offset.dy * scale);
}
