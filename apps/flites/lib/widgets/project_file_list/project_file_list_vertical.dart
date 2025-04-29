import 'package:flites/constants/app_sizes.dart';
import 'package:flites/ui/panel/panel.dart';
import 'package:flites/widgets/project_file_list/canvas_controls_overlay_button.dart';
import 'package:flites/widgets/project_file_list/widgets/main_frame_list.dart';
import 'package:flites/widgets/project_file_list/widgets/main_tool_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/main_brand.dart';

class ProjectFileListVertical extends StatelessWidget {
  const ProjectFileListVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return const Panel(
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
}
