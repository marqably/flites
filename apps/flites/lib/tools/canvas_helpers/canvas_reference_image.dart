part of 'image_editor.dart';

class _CanvasReferenceImage extends StatelessWidget {
  const _CanvasReferenceImage(this.image, {super.key});

  final FlitesImage image;

  @override
  Widget build(BuildContext context) {
    return _CanvasPositioned(
      left: image.positionOnCanvas.dx,
      top: image.positionOnCanvas.dy,
      child: Opacity(
        opacity: 0.5,
        child: FlitesImageRenderer(flitesImage: image),
      ),
    );
  }
}
