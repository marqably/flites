import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../../states/canvas_controller.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        // width: 64,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(Sizes.p32),
        ),
        child: Column(
          children: [
            IconButton(
              tooltip: context.l10n.zoomIn,
              onPressed: () {
                CanvasController.updateCanvasScale(
                  isIncreasingSize: true,
                  zoomingWithButtons: true,
                );
              },
              icon: Icon(
                Icons.zoom_in,
                size: Sizes.p24,
                color: context.colors.onSurface,
              ),
            ),
            IconButton(
              tooltip: context.l10n.zoomOut,
              onPressed: () {
                CanvasController.updateCanvasScale(
                  isIncreasingSize: false,
                  zoomingWithButtons: true,
                );
              },
              icon: Icon(
                Icons.zoom_out,
                size: Sizes.p24,
                color: context.colors.onSurface,
              ),
            ),
          ],
        ),
      );
}
