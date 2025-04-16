import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A subsection within a sidebar section (like "ALIGNMENT")
class SidebarControlWrapper extends StatelessWidget {
  final String label;
  final List<Widget> children;
  final MainAxisAlignment alignment;
  const SidebarControlWrapper({
    super.key,
    required this.label,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  }) : assert(children.length > 0,
            'You need to pass at least one item to children!');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: alignment,
      children: [
        gapH16,

        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: fontSizeBase,
            fontWeight: FontWeight.w500,
            color: context.colors.onSurface,
            letterSpacing: 1.0,
          ),
        ),

        gapH24,

        // if we have multiple children, we need to wrap them in a row
        (children.length > 1)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : children.first,
      ],
    );
  }
}
