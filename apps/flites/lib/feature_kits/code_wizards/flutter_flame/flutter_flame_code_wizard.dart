import 'package:flutter/material.dart';

import '../../../config/tools.dart';
import '../../../main.dart';
import '../../../states/tool_controller.dart';
import '../../../types/exported_sprite_image.dart';
import '../../../ui/panel/controls/panel_button.dart';
import '../../../ui/panel/controls/panel_checkbox_input.dart';
import '../../../ui/panel/panel.dart';
import '../../../ui/panel/structure/panel_form.dart';
import '../../../ui/panel/structure/panel_section.dart';
import '../../tools/export_tool/export_tool_panel.dart';
import '../base_code_wizard.dart';
import 'flutter_flame_code_generator.dart';
import 'flutter_flame_code_settings.dart';

class FlutterFlameCodeWizard
    extends BaseCodeWizard<FlutterFlameCodeGenSettings> {
  FlutterFlameCodeWizard();

  /// Uses a stub code template with placeholders for the sprite name, list of states and animation row configurations
  /// and replaces the placeholders with the actual values to then return the final generated code.
  @override
  String getInstructionsMarkdown(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
  ) =>
      FlutterFlameCodeGenerator.buildInstructionsMarkdown(
        spriteSheet,
        exportSettings,
        codeSettingsMap,
      );

  @override
  Widget getSidebarPanel(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
    Function(Map<String, dynamic>) onChanged,
  ) =>
      PanelForm(
        initialValues: FlutterFlameCodeGenSettings(
          hitboxes: true,
        ).toMap(),
        onChanged: (values) {
          onChanged(values);
        },
        child: Builder(
          builder: (context) => Panel(
            isScrollable: false,
            children: [
              PanelSection(
                label: context.l10n.codeGeneration,
                children: [
                  PanelCheckboxInput(
                    formKey: 'hitboxes',
                    checkboxLabel: context.l10n.generateHitboxCode,
                  ),
                ],
              ),
              const Spacer(),
              PanelButton(
                label: context.l10n.close,
                onPressed: () {
                  toolController.selectedTool = Tool.canvas;
                },
              ),
            ],
          ),
        ),
      );
}
