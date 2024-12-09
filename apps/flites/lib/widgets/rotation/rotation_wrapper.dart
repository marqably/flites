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
  double _rotationAngle = 0.0; // Current rotation angle in radians
  Offset _center = Offset.zero; // Center of the child

  @override
  void initState() {
    super.initState();
    _center = widget.rect.center;
  }

  void _updateRotation(Offset handlePosition) {
    final Offset center = _center;
    const Offset startVector =
        Offset(0, -1); // The "up" vector for initial angle
    final Offset currentVector = handlePosition - center;

    // Calculate the angle between the start vector and the current vector
    final double angle = atan2(currentVector.dy, currentVector.dx) -
        atan2(startVector.dy, startVector.dx);

    setState(() {
      _rotationAngle = angle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.rect.height * 0.05;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: _rotationAngle,
          origin: _center - widget.rect.topLeft,
          child: widget.child,
        ),
        Positioned(
          top: -dotSize * 4,
          child: Listener(
            onPointerDown: (event) => print('Pointer down'),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (details) {
                print('Pan starting');
                final localPosition = details.localPosition;
                _updateRotation(localPosition);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
                height: dotSize,
                width: dotSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
