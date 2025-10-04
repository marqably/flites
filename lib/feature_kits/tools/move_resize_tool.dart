import 'package:flites/main.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flites/feature_kits/tools/canvas_helpers/image_editor.dart';
import 'package:flites/feature_kits/tools/canvas_helpers/selected_image_rect_wrapper.dart';
import 'package:flites/feature_kits/tools/rotate_tool.dart';
import 'package:flites/widgets/flites_image_renderer/flites_image_renderer.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flites/widgets/player/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flites/states/source_files_state.dart';

/// Displays the current selection in move/resize mode
class MoveResizeTool extends StatefulWidget {
  const MoveResizeTool({super.key});

  @override
  State<MoveResizeTool> createState() => MoveResizeToolState();
}

class MoveResizeToolState extends State<MoveResizeTool> {
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: ImageEditor(
        stackChildren: const [
          PlayerControls(),
        ],
        child: SelectedImageRectWrapper(
          builder: (
            currentSelection,
            selectedImageRect,
          ) {
            return Watch(
              (context) {
                final rotationAngle = rotationSignal.value ?? 0;
                return TransformableBox(
                  visibleHandles:
                      rotationAngle == 0 ? HandlePosition.corners.toSet() : {},
                  enabledHandles:
                      rotationAngle == 0 ? HandlePosition.corners.toSet() : {},
                  cornerHandleBuilder: (context, handle) {
                    return AngularHandle(
                      handle: handle,
                      length: 16,
                      color: context.colors.onSurface,
                      thickness: 3,
                    );
                  },
                  resizeModeResolver: () => ResizeMode.symmetricScale,
                  rect: selectedImageRect,
                  onChanged: (result, event) {
                    currentSelection.updatePositionAndSize(
                      result.rect,
                      canvasScalingFactor.value,
                      canvasPosition.value,
                    );

                    SourceFilesState.saveImageChanges(currentSelection);
                  },
                  contentBuilder: (context, rect, flip) {
                    return FlitesImageRenderer(flitesImage: currentSelection);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
