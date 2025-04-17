part of '../image_editor.dart';

/// Displays the current selection in canvas mode
class _CanvasModeTool extends StatelessWidget {
  const _CanvasModeTool();

  @override
  Widget build(BuildContext context) {
    return _SelectedImageRectWrapper(
      builder: (
        currentSelection,
        selectedImageRect,
      ) {
        return Positioned.fromRect(
          rect: selectedImageRect,
          child: FlitesImageRenderer(flitesImage: currentSelection),
        );
      },
    );
  }
}
