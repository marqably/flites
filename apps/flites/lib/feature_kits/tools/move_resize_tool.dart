import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:signals/signals_flutter.dart';

import '../../main.dart';
import '../../states/canvas_controller.dart';
import '../../states/source_files_state.dart';
import '../../widgets/flites_image_renderer/flites_image_renderer.dart';
import '../../widgets/layout/app_shell.dart';
import '../../widgets/player/player.dart';
import 'canvas_helpers/image_editor.dart';
import 'canvas_helpers/selected_image_rect_wrapper.dart';
import 'rotate_tool.dart';

/// Displays the current selection in move/resize mode
class MoveResizeTool extends StatefulWidget {
  const MoveResizeTool({super.key});

  @override
  State<MoveResizeTool> createState() => MoveResizeToolState();
}

class MoveResizeToolState extends State<MoveResizeTool> {
  @override
  Widget build(BuildContext context) => AppShell(
        child: ImageEditor(
          stackChildren: const [
            PlayerControls(),
          ],
          child: SelectedImageRectWrapper(
            builder: (
              currentSelection,
              selectedImageRect,
            ) =>
                Watch(
              (context) {
                final rotationAngle = rotationSignal.value ?? 0;
                return TransformableBox(
                  visibleHandles:
                      rotationAngle == 0 ? HandlePosition.corners.toSet() : {},
                  enabledHandles:
                      rotationAngle == 0 ? HandlePosition.corners.toSet() : {},
                  cornerHandleBuilder: (context, handle) => AngularHandle(
                    handle: handle,
                    length: 16,
                    color: context.colors.onSurface,
                    thickness: 3,
                  ),
                  resizeModeResolver: () => ResizeMode.symmetricScale,
                  rect: selectedImageRect,
                  onChanged: (result, event) {
                    currentSelection.updatePositionAndSize(
                      result.rect,
                      CanvasController.canvasScalingFactor,
                      CanvasController.canvasPosition,
                    );

                    SourceFilesState.saveImageChanges(currentSelection);
                  },
                  contentBuilder: (context, rect, flip) =>
                      FlitesImageRenderer(flitesImage: currentSelection),
                );
              },
            ),
          ),
        ),
      );
}
