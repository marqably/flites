import 'package:flites/widgets/image_editor/image_editor.dart';
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
              canvasScalingFactorSignal.value -= 20;
            },
            icon: Icon(
              Icons.zoom_out,
              size: 28,
              color: const Color.fromARGB(255, 22, 22, 22),
            ),
          ),
          IconButton(
            onPressed: () {
              canvasScalingFactorSignal.value += 20;
            },
            icon: Icon(
              Icons.zoom_in,
              size: 28,
              color: const Color.fromARGB(255, 22, 22, 22),
            ),
          ),
        ],
      ),
    );
  }
}
