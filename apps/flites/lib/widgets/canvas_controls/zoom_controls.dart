import 'package:flites/states/canvas_controller.dart';
import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              canvasController.updateCanvasScalingFactor(-20);
            },
            icon: const Icon(
              Icons.zoom_out,
              size: 28,
              color: Color.fromARGB(255, 22, 22, 22),
            ),
          ),
          IconButton(
            onPressed: () {
              canvasController.updateCanvasScalingFactor(20);
            },
            icon: const Icon(
              Icons.zoom_in,
              size: 28,
              color: Color.fromARGB(255, 22, 22, 22),
            ),
          ),
        ],
      ),
    );
  }
}
