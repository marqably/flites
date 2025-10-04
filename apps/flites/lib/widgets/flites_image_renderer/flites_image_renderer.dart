import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../states/canvas_controller.dart';
import '../../types/flites_image.dart';
import '../../utils/svg_utils.dart';

/// Renders a [FlitesImage] on the canvas
/// with the correct scaling and rotation.
/// The image is rendered using [SvgPicture] if the image is an SVG,
/// otherwise it uses [Image.memory].
class FlitesImageRenderer extends StatelessWidget {
  const FlitesImageRenderer({
    required this.flitesImage,
    super.key,
  });

  final FlitesImage flitesImage;

  @override
  Widget build(BuildContext context) {
    final scalingFactor = CanvasController.canvasScalingFactor;

    return Transform.rotate(
      angle: flitesImage.rotation,
      child: (SvgUtils.isSvg(flitesImage.image))
          ? SvgPicture.memory(
              flitesImage.image,
              width: flitesImage.widthOnCanvas * scalingFactor,
              height: flitesImage.heightOnCanvas * scalingFactor,
            )
          : Image.memory(
              flitesImage.image,
              fit: BoxFit.contain,
              width: flitesImage.widthOnCanvas * scalingFactor,
              height: flitesImage.heightOnCanvas * scalingFactor,
            ),
    );
  }
}
