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
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          IconButton(
            tooltip: context.l10n.zoomOut,
            onPressed: () {
              canvasController.updateCanvasScalingFactor(-20);
            },
            icon: Icon(
              Icons.zoom_out,
              size: 28,
              color: context.colors.surfaceContainer,
            ),
          ),
          IconButton(
            tooltip: context.l10n.zoomIn,
            onPressed: () {
              canvasController.updateCanvasScalingFactor(20);
            },
            icon: Icon(
              Icons.zoom_in,
              size: 28,
              color: context.colors.surfaceContainer,
            ),
          ),
        ],
      ),
    );
  }
}
