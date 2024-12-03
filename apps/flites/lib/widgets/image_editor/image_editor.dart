import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/open_project.dart';
import '../../utils/get_flite_image.dart';
import '../canvas_controls/canvas_controls.dart';
import '../player/player.dart';

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
        color: Colors.grey[300],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final canvasScalingFactor = constraints.maxWidth;

          return Watch((context) {
            final currentImages = getSelectedImages();

            final referenceImage = getFliteImage(selectedReferenceImage.value);

            final enabledScaling = enableScaling.value;

            final boundingBox = allImagesBoundingBox;

            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerMoveEvent) {
                  if (currentImages.isEmpty) {
                    return;
                  }

                  final offset = pointerSignal.localDelta / canvasScalingFactor;

                  for (var i in currentImages) {
                    i.positionOnCanvas += offset;
                  }

                  setState(() {});
                }

                if (pointerSignal is PointerScrollEvent &&
                    currentImages.isNotEmpty &&
                    enabledScaling) {
                  // TODO(jaco): decrease the amount of scaling

                  scale = scale + pointerSignal.scrollDelta.dy / 1000;

                  final isInreasingSize = pointerSignal.scrollDelta.dy < 0;

                  for (final currentImage in currentImages) {
                    currentImage.widthOnCanvas = currentImage.widthOnCanvas *
                        (isInreasingSize ? 1.05 : 0.95);

                    final pointerPositionOnCanvas =
                        pointerSignal.localPosition / canvasScalingFactor;

                    final offsetFromCenter =
                        pointerPositionOnCanvas - currentImage.center;

                    currentImage.positionOnCanvas +=
                        offsetFromCenter * (isInreasingSize ? -0.05 : 0.05);
                  }

                  setState(() {});
                }
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  if (currentImages.isEmpty) {
                    return;
                  }

                  for (final currentImage in currentImages) {
                    currentImage.positionOnCanvas +=
                        details.delta / canvasScalingFactor;
                  }

                  setState(() {});
                },
                child: Stack(
                  children: [
                    if (boundingBox != null && currentImages.isNotEmpty)
                      Positioned(
                        left: boundingBox.position.dx * canvasScalingFactor,
                        top: boundingBox.position.dy * canvasScalingFactor,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).colorScheme.primary,
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
                        top: referenceImage.positionOnCanvas.dy *
                            canvasScalingFactor,
                        left: referenceImage.positionOnCanvas.dx *
                            canvasScalingFactor,
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
                          Positioned(
                        top: currentImage.positionOnCanvas.dy *
                            canvasScalingFactor,
                        left: currentImage.positionOnCanvas.dx *
                            canvasScalingFactor,
                        height:
                            currentImage.heightOnCanvas * canvasScalingFactor,
                        width: currentImage.widthOnCanvas * canvasScalingFactor,
                        child: Image.memory(
                          currentImage.image,
                        ),
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
}
