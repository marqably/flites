import 'package:flites/widgets/zoom/zoom_controls_wrapper.dart';
import 'package:flutter/material.dart';

import '../image_editor/image_editor.dart';

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZoomControlsWrapper(
      child: ImageEditor(),
    );
  }
}
