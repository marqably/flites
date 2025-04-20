import 'package:flites/tools/canvas_mode_tool.dart';
import 'package:flites/tools/move_resize_tool.dart';
import 'package:flites/tools/rotate_tool.dart';

const defaultTool = Tool.canvas;

/// Defines the available tools in the editor
enum Tool {
  canvas,
  move,
  rotate;
}

class Tools {
  static getToolWidget(Tool tool) {
    switch (tool) {
      case Tool.canvas:
        return const CanvasModeTool();
      case Tool.move:
        return const MoveResizeTool();
      case Tool.rotate:
        return const RotateTool();
    }
  }

  static enumFromString(String value) {
    for (var tool in Tool.values) {
      if (tool.name == value) {
        return tool;
      }
    }
    return null;
  }
}
