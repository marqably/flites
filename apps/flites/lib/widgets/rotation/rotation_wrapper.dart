import 'dart:math';
import 'package:flutter/material.dart';

class RotationWrapper extends StatefulWidget {
  const RotationWrapper({
    super.key,
    required this.child,
    required this.rect,
    this.onRotate,
    this.initialRotation,
  });

  final Widget child;
  final Rect rect;
  final void Function(double newAngle)? onRotate;
  final double? initialRotation;

  @override
  State<RotationWrapper> createState() => _RotationWrapperState();
}

class _RotationWrapperState extends State<RotationWrapper> {
  double rotation = 0.0;
  Offset dragStartPoint = Offset.zero;

  late final double circleRadius;

  @override
  void initState() {
    super.initState();
    circleRadius = (longestSideSize(widget.rect.size) / 2) * 1.5;
    dragStartPoint = Offset(0, circleRadius);

    rotation = widget.initialRotation ?? 0;
  }

  double calculateAngle(Offset start, Offset end) {
    double startAngle = atan2(start.dy, start.dx);
    double endAngle = atan2(end.dy, end.dx);

    double angleDifference = endAngle - startAngle;

    return angleDifference;
  }

  void _updateRotation(Offset currentPosition) {
    final newAngle =
        calculateAngle(Offset(0, 1), dragStartPoint + flipY(currentPosition));

    setState(() {
      rotation = -newAngle;
    });

    widget.onRotate?.call(rotation);
  }

  void updateStartPoint(Offset endPosition) {
    final endAngle =
        calculateAngle(dragStartPoint, dragStartPoint + flipY(endPosition));

    setState(() {
      dragStartPoint = rotateOffset(dragStartPoint, endAngle);
    });
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
              ),
              width: circleRadius * 2 - (dotSize * 2 / 3),
            ),
            Positioned(
              top: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.precise,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) {},
                  onPanUpdate: (details) {
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

    double x = offset.dx * cos(angle) - offset.dy * sin(angle);
    double y = offset.dx * sin(angle) + offset.dy * cos(angle);
    return Offset(x, y);
  }
}

// TODO(beau): refactor
// Move these functions to a fitting Utils class (as static methods)
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
