import 'package:flites/widgets/canvas/canvas_widget.dart';
import 'package:flites/widgets/canvas_controls/canvas_controls.dart';
import 'package:flites/widgets/modifiers/keyboard_modifier_wrapper.dart';
import 'package:flites/widgets/player/player_controls_wrapper.dart';
import 'package:flites/widgets/project_file_list/project_file_list_vertical.dart';
import 'package:flutter/material.dart';
import '../widgets/upload_area/file_drop_area.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const KeyboardModifierWrapper(
      child: FileDropArea(
        child: PlayerControlsWrapper(
          child: Row(
            children: [
              ProjectFileListVertical(),
              Expanded(
                child: CanvasWidget(),
              ),
              CanvasControls()
            ],
          ),
        ),
      ),
    );
  }
}
