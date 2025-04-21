import 'package:flites/feature_kits/tools/canvas_helpers/image_editor.dart';
import 'package:flites/feature_kits/tools/canvas_helpers/selected_image_rect_wrapper.dart';
import 'package:flites/widgets/flites_image_renderer/flites_image_renderer.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flutter/material.dart';

import 'hitbox_editor_overlay.dart';

/// Displays the hitbox editor
class HitboxTool extends StatelessWidget {
  const HitboxTool({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: ImageEditor(
        child: SelectedImageRectWrapper(
          builder: (
            currentSelection,
            selectedImageRect,
          ) {
            return Positioned.fromRect(
              rect: selectedImageRect,
              child: HitboxEditorOverlay(
                onHitboxPointsChanged: (points) {
                  // TODO: save the hitbox points to the active rows Image details (I already prepared a prop for it)
                  // TODO: NOTE: only the row has hitpoints. NOT every single image!!
                },
                child: Positioned.fromRect(
                  rect: selectedImageRect,
                  child: FlitesImageRenderer(flitesImage: currentSelection),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
