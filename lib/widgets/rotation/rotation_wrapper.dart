import 'dart:math';
import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/config/tools.dart';
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

    // Initialize rotation from the widget's initialRotation property
    rotation = widget.initialRotation ?? 0;

    // Set the initial drag point at the top of the circle
    // When rotation is 0, the handle should be at the top (0, -circleRadius)
    dragStartPoint = Offset(0, -circleRadius);
  }

  double calculateAngle(Offset start, Offset end) {
    // Calculate angles from the origin (0,0)
    double startAngle = atan2(start.dy, start.dx);
    double endAngle = atan2(end.dy, end.dx);

    // Return the difference between the angles
    return endAngle - startAngle;
  }

  void _updateRotation(Offset currentPosition) {
    final newAngle = calculateAngle(
        const Offset(0, -1), // Top of circle as reference
        dragStartPoint + flipY(currentPosition));

    setState(() {
      rotation = -newAngle;
    });

    // Always call the onRotate callback when rotation changes
    widget.onRotate?.call(rotation);
  }

  void updateStartPoint(Offset endPosition) {
    // When a drag ends, we need to update the dragStartPoint
    // to match the current rotation angle for the next drag

    // For a clean UX, keep the handle at the same visual position
    // by calculating the offset based on the current rotation
    final endAngle = calculateAngle(
        const Offset(0, -1), // Top of circle
        dragStartPoint + flipY(endPosition));

    setState(() {
      // Update the start point for the next drag
      // This keeps the handle visually at the position where the user released it
      dragStartPoint = rotateOffset(Offset(0, -circleRadius), endAngle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.rect.height * 0.1;

    // Get the current tool to check if we're in rotation mode
    final currentTool = toolController.selectedTool;
    final inRotationMode = currentTool == Tool.rotate;

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p48),
          child: Transform.rotate(
            origin: const Offset(0, 0),
            angle: rotation,
            child: SizedBox(
              height: circleRadius * 2,
              width: circleRadius * 2,
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
                  // Only show the rotation circle when in rotation mode
                  if (inRotationMode)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.outline,
                          width: Sizes.p2,
                        ),
                      ),
                      width: circleRadius * 2 - (dotSize * 2 / 3),
                    ),
                  // Only show the rotation handle when in rotation mode
                  if (inRotationMode)
                    Positioned(
                      top: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.precise,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (_) {},
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
                              color: context.colors.onSurface,
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
        // Only show the rotation controls when in rotation mode and rotation is not 0
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
                      widget.onRotate?.call(0);
                      dragStartPoint = Offset(0, -circleRadius);
                    },
                  ),
                  gapW8,
                  IconButton(
                    icon: Icon(
                      Icons.check_circle_outlined,
                      color: context.colors.surfaceContainer,
                    ),
                    onPressed: () async {
                      final currentImage = getFliteImage(selectedImageId.value);

                      if (currentImage != null) {
                        await currentImage.rotateImage(rotation);
                      }

                      // Reset the rotation in the UI controls
                      setState(() {
                        rotation = 0;
                        dragStartPoint = Offset(0, -circleRadius);
                      });

                      // Switch back to canvas mode after rotation is applied
                      toolController.selectTool(Tool.canvas);
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

// Helper functions for offset and size calculations
double longestSideSize(Size size) {
  return size.width > size.height ? size.width : size.height;
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
