import 'package:flites/config/tools.dart';
import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:flites/ui/panel/controls/panel_button.dart';
import 'package:flites/ui/panel/controls/panel_checkbox_input.dart';
import 'package:flites/ui/panel/panel.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';
import 'package:flites/ui/panel/structure/panel_section.dart';
import 'package:flutter/material.dart';

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
  ) {
    return FlutterFlameCodeGenerator.buildInstructionsMarkdown(
      spriteSheet,
      exportSettings,
      codeSettingsMap,
    );
  }

  @override
  Widget getSidebarPanel(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
    Function(Map<String, dynamic>) onChanged,
  ) {
    return PanelForm(
      initialValues: FlutterFlameCodeGenSettings(
        hitboxes: true,
      ).toMap(),
      onChanged: (values) {
        onChanged(values);
      },
      child: Panel(
        isScrollable: false,
        children: [
          const PanelSection(
            label: 'Code Generation',
            children: [
              PanelCheckboxInput(
                formKey: 'hitboxes',
                checkboxLabel: 'Generate hitbox code',
              ),
            ],
          ),
          const Spacer(),
          PanelButton(
            label: 'Close',
            onPressed: () {
              toolController.selectTool(Tool.canvas);
            },
          ),
        ],
      ),
    );
  }
}
