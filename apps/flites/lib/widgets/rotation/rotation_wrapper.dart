import 'dart:math';

import 'package:flutter/material.dart';

import '../../config/tools.dart';
import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../../states/selected_image_state.dart';
import '../../states/tool_controller.dart';
import '../../utils/get_flite_image.dart';

class RotationWrapper extends StatefulWidget {
  const RotationWrapper({
    required this.child,
    required this.rect,
    super.key,
  });

  final Widget child;
  final Rect rect;

  @override
  State<RotationWrapper> createState() => _RotationWrapperState();
}

class _RotationWrapperState extends State<RotationWrapper> {
  double rotation = 0;
  double _dragStartAngle = 0;
  double _rotationAtDragStart = 0;

  double get _circleRadius =>
      (longestSideSize(widget.rect.size) / 2) * 1.5;

  /// Computes the angle from the center of the rotation circle to the given
  /// local position. Returns angle in radians where 0 = top, positive = clockwise.
  double _angleFromCenter(Offset localPosition) {
    final center = Offset(_circleRadius, _circleRadius);
    final offset = localPosition - center;
    return atan2(offset.dx, -offset.dy);
  }

  String get _rotationDegrees {
    final degrees = rotation * 180 / pi;
    final normalized = (((degrees + 180) % 360) + 360) % 360 - 180;
    return '${normalized.toStringAsFixed(1)}°';
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.rect.height * 0.1;

    final currentTool = toolController.selectedTool;
    final inRotationMode = currentTool == Tool.rotate;

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p48),
          child: SizedBox(
            height: _circleRadius * 2,
            width: _circleRadius * 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotated content (image + circle + handle)
                Transform.rotate(
                  angle: rotation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: widget.rect.width,
                        height: widget.rect.height,
                        child: Center(
                          child: widget.child,
                        ),
                      ),
                      if (inRotationMode)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.colors.outline,
                              width: Sizes.p2,
                            ),
                          ),
                          width: _circleRadius * 2 - (dotSize * 2 / 3),
                        ),
                      if (inRotationMode)
                        Positioned(
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.onSurface,
                            ),
                            height: dotSize,
                            width: dotSize,
                          ),
                        ),
                    ],
                  ),
                ),
                // Gesture detector overlay in non-rotated coordinate space
                if (inRotationMode)
                  MouseRegion(
                    cursor: SystemMouseCursors.precise,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (details) {
                        _dragStartAngle =
                            _angleFromCenter(details.localPosition);
                        _rotationAtDragStart = rotation;
                      },
                      onPanUpdate: (details) {
                        final currentAngle =
                            _angleFromCenter(details.localPosition);
                        double delta = currentAngle - _dragStartAngle;
                        while (delta > pi) {
                          delta -= 2 * pi;
                        }
                        while (delta <= -pi) {
                          delta += 2 * pi;
                        }
                        setState(() {
                          rotation = _rotationAtDragStart + delta;
                        });
                      },
                      child: SizedBox(
                        width: _circleRadius * 2,
                        height: _circleRadius * 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (rotation != 0 && inRotationMode)
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.onSurface,
                borderRadius: BorderRadius.circular(Sizes.p32),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p8,
                vertical: Sizes.p4,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: context.colors.surfaceContainer,
                    ),
                    onPressed: () {
                      setState(() {
                        rotation = 0;
                      });
                    },
                  ),
                  gapW8,
                  Text(
                    _rotationDegrees,
                    style: TextStyle(
                      color: context.colors.surfaceContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  gapW8,
                  IconButton(
                    icon: Icon(
                      Icons.check_circle_outlined,
                      color: context.colors.surfaceContainer,
                    ),
                    onPressed: () async {
                      final currentImage =
                          getFliteImage(SelectedImageState.selectedImageId);

                      if (currentImage != null) {
                        await currentImage.rotateImage(rotation);
                      }

                      setState(() {
                        rotation = 0;
                      });

                      toolController.selectedTool = Tool.canvas;
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Helper function used by rotate_tool.dart
double longestSideSize(Size size) =>
    size.width > size.height ? size.width : size.height;
