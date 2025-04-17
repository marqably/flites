import 'package:flites/states/canvas_controller.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Renders a [FlitesImage] on the canvas
/// with the correct scaling and rotation.
/// The image is rendered using [SvgPicture] if the image is an SVG,
/// otherwise it uses [Image.memory].
class FlitesImageRenderer extends StatelessWidget {
  const FlitesImageRenderer({
    super.key,
    required this.flitesImage,
  });

  final FlitesImage flitesImage;

  @override
  Widget build(BuildContext context) {
    final scalingFactor = canvasScalingFactor.value;

    return Transform.rotate(
      angle: flitesImage.rotation,
      alignment: Alignment.center,
      child: (SvgUtils.isSvg(flitesImage.image))
          ? SvgPicture.memory(
              flitesImage.image,
              fit: BoxFit.contain,
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
