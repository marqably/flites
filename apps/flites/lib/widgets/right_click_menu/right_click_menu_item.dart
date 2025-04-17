// Custom widget for menu items with hover effect
import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class RightClickMenuItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  const RightClickMenuItem({
    super.key,
    required this.title,
    required this.onTap,
    this.enabled = true,
  });

  @override
  RightClickMenuItemState createState() => RightClickMenuItemState();
}

class RightClickMenuItemState extends State<RightClickMenuItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.p8),
            color: _isHovering ? context.colors.primary : Colors.transparent,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: !widget.enabled
                  ? context.colors.onSurface.withAlpha(100)
                  : _isHovering
                      ? Colors.white
                      : context.colors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
