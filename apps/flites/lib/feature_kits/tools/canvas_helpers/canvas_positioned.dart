part of 'image_editor.dart';

/// A widget that positions its child based on the canvas position and scaling factor.
class _CanvasPositioned extends StatelessWidget {
  const _CanvasPositioned({
    required this.left,
    required this.top,
    required this.child,
  });

  final double left;
  final double top;
  final Widget child;

  @override
  Widget build(BuildContext context) => Watch((context) {
        final scalingFactor = appState.canvasScalingFactor.value;
        final position = appState.canvasPosition.value;

        return Positioned(
          left: (left * scalingFactor) + position.dx,
          top: (top * scalingFactor) + position.dy,
          child: child,
        );
      });
}
