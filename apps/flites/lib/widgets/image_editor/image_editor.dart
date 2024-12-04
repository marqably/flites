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
  // double x = 100;
  // double y = 100;
  double scale = 1;
  Offset startingFocalPoint = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: LayoutBuilder(
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
                        width:
                            referenceImage.widthOnCanvas * canvasScalingFactor,
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
                        visibleHandles: const {
                          HandlePosition.bottomLeft,
                          HandlePosition.bottomRight,
                          HandlePosition.topLeft,
                          HandlePosition.topRight
                        },
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
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Image.memory(
                              currentImage.image,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

BoundingBox? get allImagesBoundingBox {
  final allImages = projectSourceFiles.value;

  if (allImages.isEmpty) {
    return null;
  }

  final topMost = allImages
      .map((e) => e.positionOnCanvas.dy)
      .fold(1.0, (value, element) => value < element ? value : element);

  final leftMost = allImages
      .map((e) => e.positionOnCanvas.dx)
      .fold(1.0, (value, element) => value < element ? value : element);

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
