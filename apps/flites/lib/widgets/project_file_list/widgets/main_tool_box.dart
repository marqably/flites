import 'package:flutter/cupertino.dart';
import 'package:signals/signals_flutter.dart';

import '../../../config/tools.dart';
import '../../../main.dart';
import '../../../states/tool_controller.dart';
import '../../../ui/inputs/icon_btn.dart';
import '../../../ui/panel/controls/panel_icon_btn_group.dart';
import '../../../ui/panel/structure/panel_section.dart';

class MainToolBox extends StatelessWidget {
  const MainToolBox({super.key});

  @override
  Widget build(BuildContext context) => Watch(
        (context) => PanelSection(
          showDivider: false,
          children: [
            PanelIconBtnGroup(
              label: context.l10n.tools,
              selectedValues: [toolController.selectedTool.name],
              onControlSelected: (value) {
                final tool = enumFromString(value);
                if (tool != null) {
                  toolController.selectedTool = tool;
                }
              },
              controls: [
                IconBtn(
                  value: Tool.canvas.name,
                  icon: CupertinoIcons.square_split_2x2,
                  tooltip: context.l10n.canvasMode,
                ),
                IconBtn(
                  value: Tool.move.name,
                  icon: CupertinoIcons.move,
                  tooltip: context.l10n.moveTool,
                ),
                IconBtn(
                  value: Tool.rotate.name,
                  icon: CupertinoIcons.rotate_right,
                  tooltip: context.l10n.rotateTool,
                ),
                IconBtn(
                  value: Tool.hitbox.name,
                  icon: CupertinoIcons.bus,
                  tooltip: context.l10n.hitboxTool,
                ),
              ],
            ),
          ],
        ),
      );
}
