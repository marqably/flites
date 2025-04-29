import 'package:flites/feature_kits/tools/export_tool/export_tool_panel.dart';
import 'package:flites/types/exported_sprite_image.dart';
import 'package:flutter/material.dart';

/// A base class for code wizards to be generated.
///
/// A code wizard is a class that generates code for a specific framework based on export settings and a image sprite map.
abstract class BaseCodeWizard<CodeGenSettingsType> {
  /// Returns the instructions markdown for the code wizard.
  String? getInstructionsMarkdown(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
  ) {
    return null;
  }

  /// Returns the sidebar panel for the code wizard.
  Widget getSidebarPanel(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
    Function(Map<String, dynamic>) onChanged,
  ) {
    return const SizedBox.shrink();
  }
}
