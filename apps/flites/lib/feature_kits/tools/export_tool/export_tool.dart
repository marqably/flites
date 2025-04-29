import 'package:flites/config/code_wizards.dart';
import 'package:flites/config/tools.dart';
import 'package:flites/feature_kits/code_wizards/code_wizard_result.dart';
import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flutter/material.dart';

/// Displays a screen to prepare the export of our sprite map
class ExportTool extends StatefulWidget {
  const ExportTool({super.key});

  @override
  State<ExportTool> createState() => _ExportToolState();
}

class _ExportToolState extends State<ExportTool> {
  ExportToolFormData? formData;
  ExportedSpriteSheetTiled? spriteSheet;

  @override
  Widget build(BuildContext context) {
    // if we want to show the code wizard -> show the code wizard instead of the export tool
    if (formData?.codeGenFramework != CodeWizards.none && spriteSheet != null) {
      return CodeWizardResult(
        spriteSheet: spriteSheet!,
        exportSettings: formData!,
      );
    }

    return AppShell(
      panelLeft: null,
      spriteMapBar: false,
      panelRight: ExportToolPanel(
        onExport: (
          ExportedSpriteSheetTiled? spriteSheetInput,
          ExportToolFormData formDataInput,
        ) {
          // if we want to generate code -> set state to switch to code wizard screen
          if (formDataInput.codeGenFramework != CodeWizards.none) {
            setState(() {
              formData = formDataInput;
              spriteSheet = spriteSheetInput;
            });
            return;
          }

          // otherwise just go back to the canvas
          toolController.selectTool(Tool.canvas);
        },
      ),
      child: const Center(
        child: Text('Configure your export on the right...'),
      ),
    );
  }
}
