import 'package:flutter/material.dart';

import '../../main.dart';
import '../image_map_widgets/sprite_map_header_wrapper.dart';
import '../project_file_list/project_file_list_vertical.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    super.key,
    this.panelLeft = const ProjectFileListVertical(),
    this.panelRight,
    this.spriteMapBar = true,
  });

  final Widget child;
  final Widget? panelLeft;
  final Widget? panelRight;
  final bool spriteMapBar;

  @override
  Widget build(BuildContext context) {
    final body = DecoratedBox(
      decoration: BoxDecoration(color: context.colors.surface),
      child: Row(
        children: [
          // left panel
          if (panelLeft != null) panelLeft!,

          // main content
          Expanded(child: child),

          // right panel
          if (panelRight != null) panelRight!,
        ],
      ),
    );

    if (spriteMapBar) {
      return SpriteMapHeaderWrapper(child: body);
    }

    return body;
  }
}
