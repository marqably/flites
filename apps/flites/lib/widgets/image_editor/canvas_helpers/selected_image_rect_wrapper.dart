part of '../image_editor.dart';

/// Displays the current selection in canvas mode
class _SelectedImageRectWrapper extends StatelessWidget {
  const _SelectedImageRectWrapper({required this.builder});

  final Widget Function(FlitesImage currentSelection, Rect selectedImageRect)
      builder;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final currentSelection = getFliteImage(selectedImageId.value);

        final selectedImageRect = currentSelection?.calculateRectOnCanvas(
          canvasPosition: canvasPosition.value,
          canvasScalingFactor: canvasScalingFactor.value,
        );

        if (currentSelection == null || selectedImageRect == null) {
          return const SizedBox.shrink();
        }
        return builder(
          currentSelection,
          selectedImageRect,
        );
      },
    );
  }
}
