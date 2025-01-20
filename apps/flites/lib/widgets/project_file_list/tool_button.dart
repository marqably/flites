import 'package:flites/main.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ToolButton extends StatelessWidget {
  const ToolButton({super.key, required this.tool, required this.icon});
  final Tool tool;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final selectedTool = toolController.selectedTool;
        final hoveredTool = toolController.hoveredTool;

        final isSelected = selectedTool == tool;
        final isHovered = hoveredTool == tool;

        return InkWell(
          onHover: (value) {
            if (value) {
              toolController.setHoveredTool(tool);
            } else {
              toolController.setHoveredTool(null);
            }
          },
          onTap: () {
            toolController.selectTool(tool);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.surfaceContainerHigh
                  : isHovered
                      ? context.colors.surfaceTint
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isSelected
                  ? context.colors.surfaceContainerLowest
                  : context.colors.onSurface,
            ),
          ),
        );
      },
    );
  }
}
