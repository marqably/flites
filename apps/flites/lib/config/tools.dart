import 'package:flites/feature_kits/tools/canvas_mode_tool.dart';
import 'package:flites/feature_kits/tools/export_tool/export_tool.dart';
import 'package:flites/feature_kits/tools/hitbox_tool/hitbox_tool.dart';
import 'package:flites/feature_kits/tools/move_resize_tool.dart';
import 'package:flites/feature_kits/tools/rotate_tool.dart';

const defaultTool = Tool.canvas;

/// Defines the available tools in the editor
enum Tool {
  canvas,
  move,
  rotate,
  hitbox,
  export;
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
      case Tool.hitbox:
        return const HitboxTool();
      case Tool.export:
        return const ExportTool();
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
