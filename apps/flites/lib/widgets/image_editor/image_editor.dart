import 'package:flites/states/key_events.dart';
import 'package:flites/states/selected_images_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/open_project.dart';
import '../../utils/get_flite_image.dart';

final showBoundingBorderSignal = signal(false);

final canvasScalingFactorSignal = signal(300.0);
final canvasPositionSignal = signal(Offset.zero);
final canvasSizePixelSignal = signal(const Size(1000, 1000));

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Watch((context) {
          canvasSizePixelSignal.value = constraints.biggest;
          final showBoundingBorder = showBoundingBorderSignal.value;
          final canvasScalingFactor =
              canvasScalingFactorSignal.value; // constraints.maxWidth;
          final currentImages = getSelectedImages();

          final canvasPosition = canvasPositionSignal.value;

          final referenceImage = getFliteImage(selectedReferenceImage.value);

          final boundingBox = allImagesBoundingBox;

          final isMainModifierPressed = modifierSignal.value.isMainPressed;

          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerMoveEvent) {
                if (currentImages.isEmpty) {
                  return;
                }

                final offset = pointerSignal.localDelta / canvasScalingFactor;

                canvasPositionSignal.value += offset;

                // for (var i in currentImages) {
                //   i.positionOnCanvas += offset;
                // }

                setState(() {});
              }

              if (pointerSignal is PointerScrollEvent &&
                  isMainModifierPressed) {
                // TODO(jaco): decrease the amount of scaling

                scale = scale + pointerSignal.scrollDelta.dy / 1000;

                final isInreasingSize = pointerSignal.scrollDelta.dy < 0;

                // for (final currentImage in currentImages) {
                //   currentImage.widthOnCanvas = currentImage.widthOnCanvas *
                //       (isInreasingSize ? 1.05 : 0.95);

                // final pointerPositionOnCanvas =
                //     pointerSignal.localPosition / canvasScalingFactor;

                final canvasCenter = Offset(
                  constraints.maxWidth / 2,
                  constraints.maxHeight / 2,
                );

                // TODO(jaco): put a square in here or so to make further
                // distance to the center more pronounced in the position
                // offset
                final offsetFromCenter =
                    canvasCenter - pointerSignal.localPosition;

                canvasPositionSignal.value -=
                    offsetFromCenter * (isInreasingSize ? -0.05 : 0.05);

                canvasScalingFactorSignal.value =
                    canvasScalingFactor * (isInreasingSize ? 1.05 : 0.95);

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
                // if (currentImages.isEmpty) {
                //   return;
                // }

                canvasPositionSignal.value += details.delta;

                // for (final currentImage in currentImages) {
                //   currentImage.positionOnCanvas +=
                //       details.delta / canvasScalingFactor;
                // }

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
                  if (boundingBox != null &&
                      currentImages.isNotEmpty &&
                      showBoundingBorder)
                    Positioned(
                      left: (boundingBox.position.dx * canvasScalingFactor) +
                          canvasPosition.dx,
                      top: (boundingBox.position.dy * canvasScalingFactor) +
                          canvasPosition.dy,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Colors
                                .white, // Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        height: boundingBox.size.height * canvasScalingFactor,
                        width: boundingBox.size.width * canvasScalingFactor,
                      ),
                    ),

                  // reference image
                  if (referenceImage != null &&
                      !currentImages
                          .map((e) => e.id)
                          .contains(referenceImage.id))
                    Positioned(
                      top: (referenceImage.positionOnCanvas.dy *
                              canvasScalingFactor) +
                          canvasPosition.dy,
                      left: (referenceImage.positionOnCanvas.dx *
                              canvasScalingFactor) +
                          canvasPosition.dx,
                      height:
                          referenceImage.heightOnCanvas * canvasScalingFactor,
                      width: referenceImage.widthOnCanvas * canvasScalingFactor,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.memory(
                          referenceImage.image,
                        ),
                      ),
                    ),

                  ...currentImages.map(
                    (currentImage) =>

                        // current image
                        TransformableBox(
                      visibleHandles: HandlePosition.corners.toSet(),

                      cornerHandleBuilder: (context, handle) {
                        return AngularHandle(
                          handle: handle,
                          length: 16,
                          color: Colors.grey[300],
                          // hasShadow: false,
                          thickness: 3,
                        );
                      },
                      resizeModeResolver: () => ResizeMode.symmetricScale,
                      // clampingRect: Rect.fromLTWH(
                      //   0,
                      //   0,
                      //   constraints.maxWidth,
                      //   constraints.maxHeight,
                      // ),
                      rect: Rect.fromLTWH(
                        (currentImage.positionOnCanvas.dx *
                                canvasScalingFactor) +
                            canvasPosition.dx,
                        (currentImage.positionOnCanvas.dy *
                                canvasScalingFactor) +
                            canvasPosition.dy,
                        currentImage.widthOnCanvas * canvasScalingFactor,
                        currentImage.heightOnCanvas * canvasScalingFactor,
                      ),
                      onChanged: (result, event) {
                        currentImage.positionOnCanvas =
                            (result.position / canvasScalingFactor) -
                                (canvasPosition / canvasScalingFactor);

                        currentImage.widthOnCanvas =
                            result.rect.width / canvasScalingFactor;

                        setState(() {});
                      },
                      contentBuilder: (context, rect, flip) {
                        // This GestureDetector ensures that the whole image
                        // is draggable inside the TransformableBox, else the
                        // invisible parts of the png become transclucent to
                        // dragging.
                        return Image.memory(
                          currentImage.image,
                        );
                      },
                    ),
                  ),

                  // TODO(jaco): using a rotation handle like this is extremely
                  // hard. It can't be a part of the above TransformableBox,
                  // because the box may not have a parent other than a Stack,
                  // if I leave the box the size of the image, then the handle
                  // would have to be placed outside of the box, making it
                  // loose it's clickablily, and if I make the child large enough
                  // then the corner handles include the rotation handle, which
                  // looks wrong
                  // ...currentImages.map(
                  //   (selectedImage) => Positioned(
                  //     left: (selectedImage.center.dx * canvasScalingFactor) +
                  //         canvasPosition.dx -
                  //         (16 / 2), // subtract dot size
                  //     top: (selectedImage.positionOnCanvas.dy *
                  //             canvasScalingFactor) +
                  //         canvasPosition.dy -
                  //         64,
                  //     child: GestureDetector(
                  //       onPanUpdate: (details) {
                  //         final localPosition = details.localPosition;

                  //         final center =
                  //             (selectedImage.center * canvasScalingFactor) +
                  //                 canvasPosition;

                  //         print(
                  //             'Selected Image Center: ${selectedImage.center}');
                  //         print(
                  //             'Canvas Scaling Factor: $canvasScalingFactor');
                  //         print('Canvas Position: $canvasPosition');

                  //         print('Local Position: $localPosition');
                  //         print('Center: $center');

                  //         //                           final Offset center = _center;
                  //         const Offset startVector = Offset(
                  //             0, -1); // The "up" vector for initial angle
                  //         final Offset currentVector = localPosition - center;

                  //         // Calculate the angle between the start vector and the current vector
                  //         final double angle =
                  //             atan2(currentVector.dy, currentVector.dx) -
                  //                 atan2(startVector.dy, startVector.dx);

                  //         _rotationAngle = angle;
                  //         setState(() {});

                  //         // setState(() {
                  //         //   _rotationAngle = angle;
                  //         // });
                  //       },
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: Colors.grey[400],
                  //         ),
                  //         height: 16,
                  //         width: 16,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
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
