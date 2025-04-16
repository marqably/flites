import 'package:flites/ui/sidebar/inputs/icon_btn.dart';
import 'package:flites/ui/sidebar/structure/sidebar_control_wrapper.dart';
import 'package:flutter/material.dart';

/// A single control button for actions like flip, rotate, etc.
class SidebarIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? value;

  const SidebarIconButton(
      {super.key,
      required this.icon,
      required this.tooltip,
      this.isSelected = false,
      this.onPressed,
      this.value});

  @override
  Widget build(BuildContext context) {
    return SidebarControlWrapper(label: tooltip, children: [
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
