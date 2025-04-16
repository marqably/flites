import 'package:flites/states/tool_controller.dart';
import 'package:flites/ui/sidebar/inputs/icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ToolButton extends StatelessWidget {
  const ToolButton({
    super.key,
    required this.tool,
    required this.icon,
    this.tooltip,
  });

  final Tool tool;
  final IconData icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final selectedTool = toolController.selectedTool;

        final isSelected = selectedTool == tool;

        return IconBtn(
          icon: icon,
          tooltip: tooltip ?? tool.toString(),
          isSelected: isSelected,
          onPressed: () {
            toolController.selectTool(tool);
          },
        );
      },
    );
  }
}
