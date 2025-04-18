import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

enum SidebarPosition {
  left,
  right,
}

class Sidebar extends StatelessWidget {
  final List<Widget> children;
  final SidebarPosition position;
  final bool isScrollable;

  const Sidebar({
    super.key,
    required this.children,
    this.position = SidebarPosition.right,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = isScrollable
        ? SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: children,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            children: children,
          );

    return Container(
      // this is just to complete the rounded corners for the primary colored bottom bar
      // this way it looks like the corners of the bottom bar go up into the sidebar
      color: context.colors.primaryFixed,
      height: double.infinity,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.only(
            bottomLeft: position == SidebarPosition.left
                ? const Radius.circular(Sizes.p8)
                : Radius.zero,
            bottomRight: position == SidebarPosition.right
                ? const Radius.circular(Sizes.p8)
                : Radius.zero,
          ),
        ),
        child: child,
      ),
    );
  }
}
