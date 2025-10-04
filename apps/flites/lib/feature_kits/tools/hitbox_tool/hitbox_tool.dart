import 'dart:math';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../constants/app_sizes.dart';
import '../../../main.dart';
import '../../../states/selected_image_row_state.dart';
import '../../../states/source_files_state.dart';
import '../../../types/flites_image.dart';
import '../../../utils/bounding_box_utils.dart';
import '../../../widgets/flites_image_renderer/flites_image_renderer.dart';
import '../../../widgets/layout/app_shell.dart';
import 'hitbox_editor_overlay.dart';

const _paddingFactor = 0.15;

/// Displays the hitbox editor
class HitboxTool extends StatelessWidget {
  const HitboxTool({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
        child: LayoutBuilder(
          builder: (context, constraints) => Watch(
            (context) {
              final boundingBox = boundingBoxOfSelectedRow;

              if (boundingBox == null) {
                return const SizedBox.shrink();
              }

              final referenceImages =
                  SourceFilesState.projectSourceFiles
                  .rows[SelectedImageRowState.selectedImageRow].images;

              final leftPoint = constraints.maxWidth * _paddingFactor;
              final topPoint = constraints.maxHeight * _paddingFactor;
              final height = constraints.maxHeight * (1 - 2 * _paddingFactor);
              final width = constraints.maxWidth * (1 - 2 * _paddingFactor);

              final widthImages = boundingBox.size.width;
              final heightImages = boundingBox.size.height;

              final scalingFactorSuchThatHeightFits = height / heightImages;

              final scalingFactorSuchThatWidthFits = width / widthImages;

              final scalingFactorToUse = min(
                scalingFactorSuchThatHeightFits,
                scalingFactorSuchThatWidthFits,
              );

              // Such that the box is centered in the canvas
              final topLeftOfBoundingBoxInHitboxCanvas = Offset(
                leftPoint + (width - widthImages * scalingFactorToUse) / 2,
                topPoint + (height - heightImages * scalingFactorToUse) / 2,
              );

              Rect translateImageToHitboxCanvas(FlitesImage image) {
                final topLeft = topLeftOfBoundingBoxInHitboxCanvas +
                    ((image.positionOnCanvas - boundingBox.position) *
                        scalingFactorToUse);

                return Rect.fromLTWH(
                  topLeft.dx,
                  topLeft.dy,
                  image.widthOnCanvas * scalingFactorToUse,
                  image.heightOnCanvas * scalingFactorToUse,
                );
              }

              final boundingBorderInHitboxCanvas = Rect.fromLTWH(
                topLeftOfBoundingBoxInHitboxCanvas.dx,
                topLeftOfBoundingBoxInHitboxCanvas.dy,
                widthImages * scalingFactorToUse,
                heightImages * scalingFactorToUse,
              );

              return HitboxEditorOverlay(
                initialHitboxPoints: SourceFilesState
                        .projectSourceFiles
                        .rows[SelectedImageRowState.selectedImageRow]
                        .hitboxPoints ??
                    [],
                boundingBox: boundingBorderInHitboxCanvas,
                onHitboxPointsChanged: SourceFilesState.saveHitBoxPoints,
                // Show all images in animation, bounding border, [_paddingFactor] padding
                child: Stack(
                  children: [
                    Positioned.fromRect(
                      rect: boundingBorderInHitboxCanvas,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: Sizes.p2,
                            color: context.colors.onSurface,
                          ),
                        ),
                        height: height,
                        width: width,
                      ),
                    ),
                    ...referenceImages.map(
                      (image) => Positioned.fromRect(
                        rect: translateImageToHitboxCanvas(image),
                        child: Opacity(
                          opacity: 0.5,
                          child: FlitesImageRenderer(flitesImage: image),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}
