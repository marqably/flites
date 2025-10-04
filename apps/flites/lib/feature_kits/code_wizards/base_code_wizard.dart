import 'package:flutter/material.dart';

import '../../types/exported_sprite_image.dart';
import '../tools/export_tool/export_tool_panel.dart';

/// A base class for code wizards to be generated.
///
/// A code wizard is a class that generates code for a specific framework based on export settings and a image sprite map.
abstract class BaseCodeWizard<CodeGenSettingsType> {
  /// Returns the instructions markdown for the code wizard.
  String? getInstructionsMarkdown(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
  ) =>
      null;

  /// Returns the sidebar panel for the code wizard.
  Widget getSidebarPanel(
    ExportedSpriteSheetTiled spriteSheet,
    ExportToolFormData exportSettings,
    Map<String, dynamic> codeSettingsMap,
    Function(Map<String, dynamic>) onChanged,
  ) =>
      const SizedBox.shrink();
}
