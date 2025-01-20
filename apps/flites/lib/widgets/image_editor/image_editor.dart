import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/key_events.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/widgets/canvas_controls/canvas_controls.dart';
import 'package:flites/widgets/rotation/rotation_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/open_project.dart';
import '../../utils/get_flite_image.dart';

class ImageEditor extends StatefulWidget {
  const ImageEditor({
    super.key,
  });

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  double scale = 1;
  Offset startingFocalPoint = const Offset(0, 0);

  bool isGrabbing = false;

  @override
  Widget build(BuildContext context) {
    // TODO(beau): refactor
    return LayoutBuilder(
      builder: (context, constraints) {
        return Watch(
          (context) {
            canvasController.updateCanvasSize(constraints.biggest);
            final showBoundingBorder = canvasController.showBoundingBorder;

            final canvasScalingFactor =
                canvasController.canvasScalingFactor; // constraints.maxWidth;

            final currentSelection = getFliteImage(selectedImage.value);

            final canvasPosition = canvasController.canvasPosition;

            final referenceImages =
                getFliteImages(selectedReferenceImages.value);

            final boundingBox = allImagesBoundingBox;

            final isMainModifierPressed = modifierSignal.value.isMainPressed;

            final rotationAngle = rotationSignal.value ?? 0;

            final selectedTool = toolController.selectedTool;

            final inCanvasMode = selectedTool == Tool.canvas;
            final inMoveMode = selectedTool == Tool.move;
            final inRotateMode = selectedTool == Tool.rotate;

            final selectedImageRect = currentSelection != null
                ? Rect.fromLTWH(
                    (currentSelection.positionOnCanvas.dx *
                            canvasScalingFactor) +
                        canvasPosition.dx,
                    (currentSelection.positionOnCanvas.dy *
                            canvasScalingFactor) +
                        canvasPosition.dy,
                    (currentSelection.widthOnCanvas * canvasScalingFactor)
                        .abs(),
                    (currentSelection.heightOnCanvas * canvasScalingFactor)
                        .abs(),
                  )
                : Rect.zero;

            final rotatedImageSize =
                (longestSideSize(selectedImageRect.size) / 2) * 3;

            final rotatedImageOffset = Offset(
              selectedImageRect.left -
                  (rotatedImageSize - selectedImageRect.width) / 2,
              selectedImageRect.top -
                  (rotatedImageSize - selectedImageRect.height) / 2,
            );

            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerMoveEvent) {
                  if (currentSelection == null) {
                    return;
                  }

                  final offset = pointerSignal.localDelta / canvasScalingFactor;

                  canvasController.updateCanvasPosition(offset);

                  setState(() {});
                }

                if (pointerSignal is PointerScrollEvent &&
                    isMainModifierPressed) {
                  // TODO(jaco): decrease the amount of scaling

                  scale = scale + pointerSignal.scrollDelta.dy / 1000;

                  final isIncreasingSize = pointerSignal.scrollDelta.dy < 0;

                  final canvasCenter = Offset(
                    constraints.maxWidth / 2,
                    constraints.maxHeight / 2,
                  );

                  // TODO(jaco): put a square in here or so to make further
                  // distance to the center more pronounced in the position
                  // offset
                  final offsetFromCenter =
                      canvasCenter - pointerSignal.localPosition;

                  canvasController.updateCanvasScale(
                    offsetFromCenter: offsetFromCenter,
                    isIncreasingSize: isIncreasingSize,
                  );

                  setState(() {});
                }
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  SelectedImagesController().clearSelection();
                },
                onPanStart: (details) {
                  setState(() {
                    isGrabbing = true;
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    isGrabbing = false;
                  });
                },
                onPanUpdate: (details) {
                  canvasController.updateCanvasPosition(details.delta);
                  setState(() {});
                },
                child: Stack(
                  children: [
                    MouseRegion(
                      cursor: isGrabbing
                          ? SystemMouseCursors.grabbing
                          : SystemMouseCursors.grab,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),

                    // Bounding Box
                    if (boundingBox != null && showBoundingBorder)
                      Positioned(
                        key: ValueKey(
                            '${boundingBox.hashCode}${currentSelection?.rotation}'),
                        left: (boundingBox.position.dx * canvasScalingFactor) +
                            canvasPosition.dx,
                        top: (boundingBox.position.dy * canvasScalingFactor) +
                            canvasPosition.dy,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                          ),
                          height: boundingBox.size.height * canvasScalingFactor,
                          width: boundingBox.size.width * canvasScalingFactor,
                        ),
                      ),

                    // reference images
                    ...referenceImages.map(
                      (image) => Positioned(
                        top: (image.positionOnCanvas.dy * canvasScalingFactor) +
                            canvasPosition.dy,
                        left:
                            (image.positionOnCanvas.dx * canvasScalingFactor) +
                                canvasPosition.dx,
                        height: image.heightOnCanvas * canvasScalingFactor,
                        width: image.widthOnCanvas * canvasScalingFactor,
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.memory(
                            image.image,
                          ),
                        ),
                      ),
                    ),

                    /// Showing selected image
                    if (currentSelection != null && inCanvasMode)
                      Positioned.fromRect(
                        rect: selectedImageRect,
                        child: Image.memory(
                          currentSelection.image,
                        ),
                      ),

                    /// Rotating selected image
                    if (currentSelection != null && inRotateMode)
                      Positioned(
                        top: rotatedImageOffset.dy,
                        left: rotatedImageOffset.dx,
                        child: RotationWrapper(
                          key: ValueKey(currentSelection.id +
                              canvasScalingFactor.toString()),
                          rect: selectedImageRect,
                          onRotate: (newAngle) {
                            currentSelection.rotation = newAngle;
                          },
                          initialRotation: currentSelection.rotation,
                          child: Image.memory(
                            currentSelection.image,
                          ),
                        ),
                      ),

                    if (currentSelection != null && inMoveMode)
                      TransformableBox(
                        visibleHandles: rotationAngle == 0
                            ? HandlePosition.corners.toSet()
                            : {},
                        enabledHandles: rotationAngle == 0
                            ? HandlePosition.corners.toSet()
                            : {},
                        cornerHandleBuilder: (context, handle) {
                          return AngularHandle(
                            handle: handle,
                            length: 16,
                            color: Colors.grey[300],
                            thickness: 3,
                          );
                        },
                        resizeModeResolver: () => ResizeMode.symmetricScale,
                        rect: selectedImageRect,
                        onChanged: (result, event) {
                          currentSelection.positionOnCanvas =
                              (result.position / canvasScalingFactor) -
                                  (canvasPosition / canvasScalingFactor);

                          currentSelection.widthOnCanvas =
                              result.rect.width / canvasScalingFactor;

                          setState(() {});
                        },
                        contentBuilder: (context, rect, flip) {
                          return Image.memory(
                            currentSelection.image,
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

BoundingBox? get allImagesBoundingBox {
  final allImages = projectSourceFiles.value;

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
