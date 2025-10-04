// lib/widgets/image_editor/image_editor.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_state.dart';
import '../../../main.dart';
import '../../../states/canvas_controller.dart';
import '../../../states/key_events.dart';
import '../../../states/open_project.dart';
import '../../../states/selected_image_state.dart';
import '../../../types/flites_image.dart';
import '../../../utils/bounding_box_utils.dart';
import '../../../utils/get_flite_image.dart';
import '../../../widgets/flites_image_renderer/flites_image_renderer.dart';
import '../../../widgets/tool_controls/zoom_controls.dart';

part 'canvas_bounding_box.dart';
part 'canvas_gesture_handler.dart';
part 'canvas_positioned.dart';
part 'canvas_reference_image.dart';

/// A widget that provides a canvas for editing images.
/// It allows users to move, resize, and rotate images on the canvas.
/// The canvas is responsive and adjusts its size based on the available space.
/// The canvas also supports zooming and panning using gestures.
class ImageEditor extends StatelessWidget {
  const ImageEditor({
    required this.child,
    super.key,
    this.showZoomControls = true,
    this.stackChildren = const [],
  });
  final Widget child;
  final bool showZoomControls;
  final List<Widget> stackChildren;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          CanvasController.updateCanvasSize(constraints.biggest);

          return Watch(
            (context) {
              final referenceImages =
                  getFliteImages(selectedReferenceImages.value);

              // We're subscribing to the canvas scaling factor
              // to ensure the reference images update correctly
              // when the canvas is zoomed in or out.
              appState.canvasScalingFactor.value;

              return _CanvasGestureHandler(
                child: Stack(
                  children: [
                    // Canvas Background
                    background(context),

                    // Bounding Box
                    const _CanvasBoundingBox(),

                    // Reference Images
                    ...referenceImages.map(
                      CanvasReferenceImage.new,
                    ),

                    // Tool-specific canvases
                    child,

                    // Zoom Controls
                    if (showZoomControls)
                      const Positioned(
                        right: Sizes.p32,
                        bottom: Sizes.p32,
                        child: ZoomControls(),
                      ),

                    // Additional widgets to be displayed on top of the canvas
                    ...stackChildren,
                  ],
                ),
              );
            },
          );
        },
      );

  Widget background(BuildContext context) => Container(
        decoration: BoxDecoration(color: context.colors.surface),
      );
}
