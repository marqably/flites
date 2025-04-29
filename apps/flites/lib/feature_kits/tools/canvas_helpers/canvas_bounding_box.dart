part of 'image_editor.dart';

/// Displays the current selection in canvas mode
class _CanvasBoundingBox extends StatelessWidget {
  const _CanvasBoundingBox();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final boundingBox = boundingBoxOfSelectedRow;

        if (boundingBox == null || !showBoundingBorder.value) {
          return const SizedBox.shrink();
        }

        return _CanvasPositioned(
          left: boundingBox.position.dx,
          top: boundingBox.position.dy,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: Sizes.p4,
                color: context.colors.surfaceContainerLowest,
              ),
            ),
            height: boundingBox.size.height * canvasScalingFactor.value,
            width: boundingBox.size.width * canvasScalingFactor.value,
          ),
        );
      },
    );
  }
}
