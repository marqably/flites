import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A subsection within a sidebar section (like "ALIGNMENT")
class SidebarSubsection extends StatelessWidget {
  final String title;
  final Widget child;

  const SidebarSubsection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH16,
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.colors.onSurface,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8.0),
        child,
        gapH16,
      ],
    );
  }
}
