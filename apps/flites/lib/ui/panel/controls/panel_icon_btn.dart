import 'package:flutter/material.dart';

import '../../inputs/icon_btn.dart';
import '../structure/panel_control_wrapper.dart';

/// A single control button for actions like flip, rotate, etc.
class PanelIconButton extends StatelessWidget {
  const PanelIconButton({
    required this.icon,
    required this.tooltip,
    super.key,
    this.isSelected = false,
    this.onPressed,
    this.value,
  });
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? value;

  @override
  Widget build(BuildContext context) => PanelControlWrapper(
        label: tooltip,
        helpText: tooltip,
        children: [
          IconBtn(
            icon: icon,
            tooltip: tooltip,
            isSelected: isSelected,
            onPressed: onPressed,
            value: value,
          ),
        ],
      );
}
