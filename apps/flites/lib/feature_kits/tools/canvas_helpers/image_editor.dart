// lib/widgets/image_editor/image_editor.dart
import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/states/key_events.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/bounding_box_utils.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flites/widgets/flites_image_renderer/flites_image_renderer.dart';
import 'package:flites/widgets/tool_controls/zoom_controls.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

part 'canvas_gesture_handler.dart';
part 'canvas_bounding_box.dart';
part 'canvas_reference_image.dart';
part 'canvas_positioned.dart';

/// A widget that provides a canvas for editing images.
/// It allows users to [move], [resize], and [rotate] images on the canvas.
/// The canvas is responsive and adjusts its size based on the available space.
/// The canvas also supports zooming and panning using gestures.
class ImageEditor extends StatelessWidget {
  final Widget child;
  final bool showZoomControls;
  final List<Widget> stackChildren;

  const ImageEditor({
    super.key,
    required this.child,
    this.showZoomControls = true,
    this.stackChildren = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        CanvasController.updateCanvasSize(constraints.biggest);

        return Watch(
          (context) {
            final referenceImages =
                getFliteImages(selectedReferenceImages.value);

            return _CanvasGestureHandler(
              child: Stack(
                children: [
                  // Canvas Background
                  background(context),

                  // Bounding Box
                  const _CanvasBoundingBox(),

                  // Reference Images
                  ...referenceImages.map(
                    (image) => CanvasReferenceImage(
                      image,
                      key: ValueKey(image.id),
                    ),
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
  }

  Widget background(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.colors.surface),
    );
  }
}
