import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../ui/panel/panel.dart';
import 'canvas_controls_overlay_button.dart';
import 'widgets/main_brand.dart';
import 'widgets/main_frame_list.dart';
import 'widgets/main_tool_box.dart';

class ProjectFileListVertical extends StatelessWidget {
  const ProjectFileListVertical({super.key});

  @override
  Widget build(BuildContext context) => const Panel(
        position: PanelPosition.left,
        isScrollable: false,
        children: [
          Flexible(flex: 0, child: MainBrand()),
          gapH8,
          Flexible(flex: 0, child: MainToolBox()),
          Expanded(child: MainFrameList()),
          gapH32,
          Flexible(
            flex: 0,
            child: Padding(
              padding: EdgeInsets.all(Sizes.p16),
              child: Row(
                children: [
                  CanvasControlsButton(),
                ],
              ),
            ),
          ),
        ],
      );
}
