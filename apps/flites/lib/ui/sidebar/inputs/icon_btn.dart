import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

enum IconBtnSize {
  xxs,
  xs,
  sm,
  md,
  lg,
  xl;

  double get getNumericSize {
    switch (this) {
      case IconBtnSize.xxs:
        return Sizes.p12;
      case IconBtnSize.xs:
        return Sizes.p16;
      case IconBtnSize.sm:
        return Sizes.p20;
      case IconBtnSize.md:
        return Sizes.p24;
      case IconBtnSize.lg:
        return Sizes.p32;
      case IconBtnSize.xl:
        return Sizes.p40;
    }
  }
}

/// A single control button for actions like flip, rotate, etc.
class IconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback? onPressed;
  final String? value;
  final IconBtnSize size;
  final Color? color;

  const IconBtn({
    super.key,
    required this.icon,
    required this.tooltip,
    this.isSelected = false,
    this.onPressed,
    this.value,
    this.size = IconBtnSize.md,
    this.color,
  }) : assert(value != null || onPressed != null,
            'Either value or onPressed must be provided');

  @override
  State<IconBtn> createState() => _IconBtnState();

  IconBtn copyWith({
    IconData? icon,
    String? tooltip,
    bool? isSelected,
    VoidCallback? onPressed,
    String? value,
    IconBtnSize? size,
    Color? color,
  }) {
    return IconBtn(
      icon: icon ?? this.icon,
      tooltip: tooltip ?? this.tooltip,
      isSelected: isSelected ?? this.isSelected,
      onPressed: onPressed ?? this.onPressed,
      value: value ?? this.value,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}

class _IconBtnState extends State<IconBtn> {
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
                    : widget.color ?? context.colors.surface,
            borderRadius: BorderRadius.circular(Sizes.p4),
          ),
          child: Icon(
            widget.icon,
            size: widget.size.getNumericSize,
            color: widget.isSelected
                ? context.colors.onPrimary
                : context.colors.onSurface,
          ),
        ),
      ),
    );
  }
}
