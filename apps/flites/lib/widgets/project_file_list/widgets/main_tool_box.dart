import 'package:flites/main.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/tools.dart';
import 'package:flites/ui/panel/controls/panel_icon_btn_group.dart';
import 'package:flites/ui/inputs/icon_btn.dart';
import 'package:flites/ui/panel/structure/panel_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:signals/signals_flutter.dart';

class MainToolBox extends StatelessWidget {
  const MainToolBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return PanelSection(
        showDivider: false,
        children: [
          PanelIconBtnGroup(
            label: context.l10n.tools,
            selectedValues: [toolController.selectedTool.name],
            spacing: PanelIconBtnSpacing.normal,
            onControlSelected: (value) {
              toolController.selectTool(Tools.enumFromString(value));
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
                value: Tool.export.name,
                icon: CupertinoIcons.bus,
                tooltip: context.l10n.hitboxTool,
              ),
            ],
          ),
        ],
      );
    });
  }
}
