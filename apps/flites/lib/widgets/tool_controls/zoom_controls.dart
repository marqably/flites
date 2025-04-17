import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/canvas_controller.dart';
import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 64,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Sizes.p32),
      ),
      child: Column(
        children: [
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
        ],
      ),
    );
  }
}
