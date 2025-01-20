import 'dart:math';
import 'package:flites/main.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/utils/get_flite_image.dart';
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
    final newAngle = calculateAngle(
        const Offset(0, 1), dragStartPoint + flipY(currentPosition));

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

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Transform.rotate(
            origin: const Offset(0, 0),
            angle: rotation,
            child: SizedBox(
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
                        color: context.colors.outline,
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
                          _updateRotation(standardizeOffsetToRotation(
                              details.localPosition));
                        },
                        onPanEnd: (details) {
                          updateStartPoint(standardizeOffsetToRotation(
                              details.localPosition));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.onSurfaceVariant,
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
          ),
        ),
        if (rotation != 0)
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: () {
                      setState(() {
                        rotation = 0;
                      });
                      widget.onRotate?.call(0);
                      dragStartPoint = Offset(0, circleRadius);
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      final currentImage = getFliteImage(selectedImage.value);

                      if (currentImage != null) {
                        currentImage.trimImage();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
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
// from Ben: maybe an abstract class
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
