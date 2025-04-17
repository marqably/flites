part of '../image_editor.dart';

/// Displays the current selection in move/resize mode
class _MoveResizeTool extends StatefulWidget {
  const _MoveResizeTool();

  @override
  State<_MoveResizeTool> createState() => _MoveResizeToolState();
}

class _MoveResizeToolState extends State<_MoveResizeTool> {
  @override
  Widget build(BuildContext context) {
    return _SelectedImageRectWrapper(
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

                setState(() {});
              },
              contentBuilder: (context, rect, flip) {
                return FlitesImageRenderer(flitesImage: currentSelection);
              },
            );
          },
        );
      },
    );
  }
}
