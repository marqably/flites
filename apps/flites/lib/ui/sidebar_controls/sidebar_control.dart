import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A single control button for actions like flip, rotate, etc.
class SidebarControl extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? value;

  const SidebarControl({
    super.key,
    required this.icon,
    required this.tooltip,
    this.isSelected = false,
    this.onPressed,
    this.value,
  }) : assert(value != null || onPressed != null,
            'Either value or onPressed must be provided');

  @override
  State<SidebarControl> createState() => _SidebarControlState();
}

class _SidebarControlState extends State<SidebarControl> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? context.colors.primary
                : isHovered
                    ? context.colors.surfaceContainer
                    : context.colors.surface,
            borderRadius: BorderRadius.circular(Sizes.p4),
          ),
          child: Icon(
            widget.icon,
            size: Sizes.p24,
            color: context.colors.onSurface,
          ),
        ),
      ),
    );
  }
}
