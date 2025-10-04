// Custom widget for menu items with hover effect
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

const rightClickMenuItemHeight = Sizes.p32;

class RightClickMenuItem extends StatefulWidget {
  const RightClickMenuItem({
    required this.title,
    required this.onTap,
    super.key,
    this.enabled = true,
  });
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  @override
  RightClickMenuItemState createState() => RightClickMenuItemState();
}

class RightClickMenuItemState extends State<RightClickMenuItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (event) => setState(() => _isHovering = true),
        onExit: (event) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.enabled ? widget.onTap : null,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.p8),
              color: _isHovering ? context.colors.primary : Colors.transparent,
            ),
            width: double.infinity,
            height: rightClickMenuItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
