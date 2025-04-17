import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/selected_image_state.dart';
import 'package:flites/widgets/project_file_list/canvas_controls_overlay_button.dart';
import 'package:flites/widgets/project_file_list/hoverable_widget.dart';
import 'package:flites/widgets/project_file_list/settings_overlay_button.dart';
import 'package:flites/widgets/project_file_list/widgets/main_frame_list.dart';
import 'package:flites/widgets/project_file_list/widgets/main_tool_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ProjectFileListVertical extends StatefulWidget {
  const ProjectFileListVertical({super.key});

  @override
  State<ProjectFileListVertical> createState() =>
      _ProjectFileListVerticalState();
}

class _ProjectFileListVerticalState extends State<ProjectFileListVertical> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: remove this unneeded watch
    return Watch(
      (context) {
        return GestureDetector(
          onTap: () {
            SelectedImageState.clearSelection();
          },
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Sizes.p8),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH16,

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
                        gapW16,
                        SettingsOverlayButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
