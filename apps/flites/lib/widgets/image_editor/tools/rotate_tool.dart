part of '../image_editor.dart';

/// Displays the current selection in rotate mode
class _RotateTool extends StatelessWidget {
  const _RotateTool();

  @override
  Widget build(BuildContext context) {
    return _SelectedImageRectWrapper(
      builder: (
        currentSelection,
        selectedImageRect,
      ) {
        final rotatedImageSize =
            (longestSideSize(selectedImageRect.size) / 2) * 3;

        final rotatedImageOffset = Offset(
          selectedImageRect.left -
              (rotatedImageSize - selectedImageRect.width) / 2,
          selectedImageRect.top -
              (rotatedImageSize - selectedImageRect.height) / 2,
        );

        return Positioned(
          top: rotatedImageOffset.dy,
          left: rotatedImageOffset.dx,
          child: RotationWrapper(
            key: ValueKey(currentSelection.id +
                canvasScalingFactor.toString() +
                Tool.rotate.toString() +
                DateTime.now().millisecondsSinceEpoch.toString()),
            rect: selectedImageRect,
            onRotate: (newAngle) {
              currentSelection.rotation = newAngle;
            },
            initialRotation: currentSelection.rotation,
            child: SizedBox(
              width: selectedImageRect.width,
              height: selectedImageRect.height,
              child: FlitesImageRenderer(flitesImage: currentSelection),
            ),
          ),
        );
      },
    );
  }
}
