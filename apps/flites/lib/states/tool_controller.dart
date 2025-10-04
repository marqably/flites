import 'package:signals/signals_flutter.dart';

import '../config/tools.dart';

/// A controller for managing tool selection and hover states
class ToolController {
  /// Signal for the currently selected tool
  final _selectedToolSignal = signal(defaultTool);

  // Getters for accessing signal values
  Tool get selectedTool => _selectedToolSignal.value;

  /// Updates the selected tool
  set selectedTool(Tool tool) {
    _selectedToolSignal.value = tool;
  }
}

/// The global tool controller instance
final toolController = ToolController();
