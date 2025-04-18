import 'package:flites/ui/inputs/icon_btn.dart';
import 'package:flites/ui/panel/structure/panel_control_wrapper.dart';
import 'package:flutter/material.dart';

/// A single control button for actions like flip, rotate, etc.
class PanelIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? value;

  const PanelIconButton(
      {super.key,
      required this.icon,
      required this.tooltip,
      this.isSelected = false,
      this.onPressed,
      this.value});

  @override
  Widget build(BuildContext context) {
    return PanelControlWrapper(label: tooltip, children: [
      IconBtn(
        icon: icon,
        tooltip: tooltip,
        isSelected: isSelected,
        onPressed: onPressed,
        value: value,
      ),
    ]);
  }
}
