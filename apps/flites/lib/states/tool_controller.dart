import 'package:signals/signals_flutter.dart';

/// Defines the available tools in the editor
enum Tool {
  canvas,
  move,
  rotate,
}

/// A controller for managing tool selection and hover states
class ToolController {
  /// Signal for the currently selected tool
  final _selectedToolSignal = signal(Tool.canvas);

  /// Signal for the currently hovered tool
  final _hoveredToolSignal = signal<Tool?>(null);

  // Getters for accessing signal values
  Tool get selectedTool => _selectedToolSignal.value;
  Tool? get hoveredTool => _hoveredToolSignal.value;

  /// Updates the selected tool
  void selectTool(Tool tool) {
    _selectedToolSignal.value = tool;
  }

  /// Updates the hovered tool
  void setHoveredTool(Tool? tool) {
    _hoveredToolSignal.value = tool;
  }
}

/// The global tool controller instance
final toolController = ToolController();
