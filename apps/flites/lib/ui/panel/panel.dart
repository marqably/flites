import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

enum PanelPosition {
  left,
  right,
}

class Panel extends StatelessWidget {
  const Panel({
    required this.children,
    super.key,
    this.position = PanelPosition.right,
    this.isScrollable = true,
  });
  final List<Widget> children;
  final PanelPosition position;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final child = isScrollable
        ? SingleChildScrollView(
            child: Column(
              children: children,
            ),
          )
        : Column(
            children: children,
          );

    return Container(
      // this is just to complete the rounded corners for the primary colored bottom bar
      // this way it looks like the corners of the bottom bar go up into the panel
      color: context.colors.primaryFixed,
      height: double.infinity,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.only(
            bottomLeft: position == PanelPosition.left
                ? const Radius.circular(Sizes.p8)
                : Radius.zero,
            bottomRight: position == PanelPosition.right
                ? const Radius.circular(Sizes.p8)
                : Radius.zero,
          ),
        ),
        child: child,
      ),
    );
  }
}
