import 'package:flites/tools/canvas_helpers/image_editor.dart';
import 'package:flites/tools/canvas_helpers/selected_image_rect_wrapper.dart';
import 'package:flites/widgets/flites_image_renderer/flites_image_renderer.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flites/widgets/player/player.dart';
import 'package:flites/widgets/upload_area/file_drop_area.dart';
import 'package:flutter/material.dart';

/// Displays the current selection in canvas mode
class CanvasModeTool extends StatelessWidget {
  const CanvasModeTool({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: ImageEditor(
        stackChildren: const [
          PlayerControls(),
        ],
        child: SelectedImageRectWrapper(
          builder: (
            currentSelection,
            selectedImageRect,
          ) {
            return Positioned.fromRect(
              rect: selectedImageRect,
              child: FileDropArea(
                child: Container(
                  width: 600,
                  height: 600,
                  color: Colors.red,
                ),
                // Positioned.fromRect(
                //     rect: selectedImageRect,
                //     child: FlitesImageRenderer(flitesImage: currentSelection),
                //   )
              ),
            );
          },
        ),
      ),
    );
  }
}
