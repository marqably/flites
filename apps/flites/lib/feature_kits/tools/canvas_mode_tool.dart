import 'package:flutter/material.dart';

import '../../widgets/flites_image_renderer/flites_image_renderer.dart';
import '../../widgets/layout/app_shell.dart';
import '../../widgets/player/player.dart';
import 'canvas_helpers/image_editor.dart';
import 'canvas_helpers/selected_image_rect_wrapper.dart';

/// Displays the current selection in canvas mode
class CanvasModeTool extends StatelessWidget {
  const CanvasModeTool({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
        child: ImageEditor(
          stackChildren: const [
            PlayerControls(),
          ],
          child: SelectedImageRectWrapper(
            builder: (
              currentSelection,
              selectedImageRect,
            ) =>
                Positioned.fromRect(
              rect: selectedImageRect,
              child: FlitesImageRenderer(flitesImage: currentSelection),
            ),
          ),
        ),
      );
}
