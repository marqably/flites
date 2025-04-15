import 'package:signals/signals_flutter.dart';

/// Defines the available tools in the editor
enum Tool {
  canvas,
  move,
  rotate,
  hitbox,
}

/// A controller for managing tool selection and hover states
class ToolController {
  /// Signal for the currently selected tool
  final _selectedToolSignal = signal(Tool.canvas);

  /// Signal for the currently hovered tool
  final _toolSettings = signal<Map<String, Map<String, dynamic>>?>({});

  // Getters for accessing signal values
  Tool get selectedTool => _selectedToolSignal.value;

  /// Updates the selected tool
  void selectTool(Tool tool) {
    _selectedToolSignal.value = tool;
  }

  /// Updates the tool settings with a specific key and value
  void setToolSettings(String tool, String key, String value) {
    final currentSettings = _toolSettings.value != null
        ? {..._toolSettings.value!}
        : <String, Map<String, dynamic>>{};
    currentSettings[tool] = {
      ...(currentSettings[tool] ?? {}),
      key: value,
    };

    _toolSettings.value = currentSettings;
  }

  /// Returns a specific tool setting value
  ValueType getToolSetting<ValueType>(
      String tool, String key, ValueType defaultValue) {
    final settings = _toolSettings.value;

    if (settings?[tool]?[key] == null) {
      return defaultValue;
    }

    return settings?[tool]?[key] as ValueType;
  }
}

/// The global tool controller instance
final toolController = ToolController();
