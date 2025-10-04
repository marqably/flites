part of 'image_editor.dart';

/// Displays the current selection in canvas mode
class _CanvasBoundingBox extends StatelessWidget {
  const _CanvasBoundingBox();

  @override
  Widget build(BuildContext context) => Watch(
        (context) {
          final boundingBox = boundingBoxOfSelectedRow;

          if (boundingBox == null || !appState.showBoundingBorder.value) {
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
              height:
                  boundingBox.size.height * appState.canvasScalingFactor.value,
              width:
                  boundingBox.size.width * appState.canvasScalingFactor.value,
            ),
          );
        },
      );
}
