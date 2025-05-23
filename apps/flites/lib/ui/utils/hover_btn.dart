import 'package:flutter/material.dart';

class HoverBtn extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  final Color? color;
  final void Function(bool)? onHover;
  final String? tooltip;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final void Function(TapDownDetails)? onTapDown;
  final void Function()? onTapCancel;
  final void Function(bool)? onHighlightChanged;
  final void Function(bool)? onFocusChange;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? splashColor;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final bool disableHoverEffect;

  const HoverBtn({
    super.key,
    required this.child,
    required this.hoverColor,
    this.color = Colors.transparent,
    this.onHover,
    this.tooltip,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onFocusChange,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.disableHoverEffect = false,
  });

  @override
  State<HoverBtn> createState() => _HoverBtnState();
}

class _HoverBtnState extends State<HoverBtn> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: InkWell(
        onHover: (val) {
          setState(() {
            _isHovering = val;
          });
          widget.onHover?.call(val);
        },
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        onLongPress: widget.onLongPress,
        onTapDown: widget.onTapDown,
        onTapCancel: widget.onTapCancel,
        onHighlightChanged: widget.onHighlightChanged,
        onFocusChange: widget.onFocusChange,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor,
        radius: widget.radius,
        borderRadius: widget.borderRadius,
        customBorder: widget.customBorder,
        enableFeedback: widget.enableFeedback,
        excludeFromSemantics: widget.excludeFromSemantics,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering && !widget.disableHoverEffect
                ? widget.hoverColor
                : widget.color,
            borderRadius: widget.borderRadius,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
