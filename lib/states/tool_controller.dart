import 'package:flites/config/tools.dart';
import 'package:signals/signals_flutter.dart';

/// A controller for managing tool selection and hover states
class ToolController {
  /// Signal for the currently selected tool
  final _selectedToolSignal = signal(defaultTool);

  // Getters for accessing signal values
  Tool get selectedTool => _selectedToolSignal.value;

  /// Updates the selected tool
  void selectTool(Tool tool) {
    _selectedToolSignal.value = tool;
  }
}

/// The global tool controller instance
final toolController = ToolController();
