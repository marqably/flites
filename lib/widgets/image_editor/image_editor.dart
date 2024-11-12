import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  double x = 0;
  double y = 0;
  double scale = 1;
  Offset startingFocalPoint = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final currentImage = getFliteImage(selectedImage.value);
      final referenceImage = getFliteImage(selectedReferenceImage.value);

      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () {
              currentImage?.saveChanges(
                margin: EdgeInsets.only(left: -x, top: -y),
                scalingFactor: scale,
              );
            },
            child: const Text('Save Positioning'),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(16),
              child: Stack(children: [
                // reference image
                if (referenceImage != null)
                  Positioned(
                    child: Image.memory(
                      referenceImage.image,
                    ),
                  ),

                // current image
                if (currentImage != null)
                  Positioned(
                    top: y,
                    left: x,
                    child: Opacity(
                      // if we have a reference image, we want to show the current image with a lower opacity
                      opacity: referenceImage != null ? 0.5 : 1,
                      child: Positioned(
                          child: Transform.scale(
                        scale: scale,
                        child: Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              scale =
                                  scale + pointerSignal.scrollDelta.dy / 1000;
                              setState(() {});
                            }
                          },
                          child: GestureDetector(
                            onScaleStart: (detail) {
                              startingFocalPoint = detail.focalPoint;
                            },
                            onScaleUpdate: (detail) {
                              if (detail.pointerCount > 2) {
                                return;
                              }
                              if (detail.pointerCount == 2) {
                                scale = detail.scale;
                                setState(() {});
                                return;
                              }
                              final endingFocalPoint = detail.focalPoint;
                              final offset =
                                  endingFocalPoint - startingFocalPoint;
                              y = y + offset.dy;
                              x = x + offset.dx;
                              startingFocalPoint = endingFocalPoint;
                              setState(() {});
                            },
                            child: Image.memory(
                              currentImage.image,
                            ),
                          ),
                        ),
                      )),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      );
    });
  }
}
