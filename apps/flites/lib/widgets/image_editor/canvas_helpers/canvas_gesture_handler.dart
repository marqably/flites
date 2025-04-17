part of '../image_editor.dart';

final _isGrabbing = Signal<bool>(false);

/// Handles gestures on the canvas to update the canvas position and scale
class _CanvasGestureHandler extends StatelessWidget {
  const _CanvasGestureHandler({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerMoveEvent &&
                getFliteImage(selectedImageId.value) == null) {
              final offset =
                  pointerSignal.localDelta / canvasScalingFactor.value;
              CanvasController.updateCanvasPosition(offset);
            }

            if (pointerSignal is PointerScrollEvent &&
                modifierSignal.value.isMainPressed) {
              final isIncreasingSize = pointerSignal.scrollDelta.dy < 0;
              final canvasCenter = Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2,
              );

              final offsetFromCenter =
                  canvasCenter - pointerSignal.localPosition;

              CanvasController.updateCanvasScale(
                offsetFromCenter: offsetFromCenter,
                isIncreasingSize: isIncreasingSize,
              );
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: SelectedImageState.clearSelection,
            onPanStart: (details) {
              _isGrabbing.value = true;
            },
            onPanEnd: (details) {
              _isGrabbing.value = false;
            },
            onPanUpdate: (details) {
              CanvasController.updateCanvasPosition(details.delta);
            },
            child: MouseRegion(
              cursor: _isGrabbing.value
                  ? SystemMouseCursors.grabbing
                  : SystemMouseCursors.grab,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
