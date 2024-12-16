import 'package:flites/widgets/blocking_widget/blocking_container.dart';
import 'package:flites/widgets/canvas_controls/canvas_controls.dart';
import 'package:flites/widgets/canvas_controls/zoom_controls.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flites/widgets/project_file_list/project_file_list_vertical.dart';
import 'package:flutter/material.dart';
import '../states/key_events.dart';
import '../widgets/player/player.dart';
import '../widgets/upload_area/file_drop_area.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void initState() {
    super.initState();

    ModifierController.listenToGlobalKeyboardEvents();
  }

  @override
  Widget build(BuildContext context) {
    return const FileDropArea(
        child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
          children: [
            ProjectFileListVertical(),
            Expanded(
              child: Stack(
                children: [
                  ImageEditor(),
                  Positioned(
                    right: 32,
                    bottom: 32,
                    child: ZoomControls(),
                  ),
                ],
              ),
            ),
            CanvasControls()
          ],
        ),
        BlockingContainer(),
        Positioned(
          bottom: 64,
          child: PlayerControls(),
        ),
      ],
    )

        // Padding(
        //   padding: EdgeInsets.all(16),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       // main interface
        //       Expanded(
        //         child: Row(
        //           children: [
        //             // image editor
        //             Expanded(
        //               flex: 3,
        //               child: ImageEditor(),
        //             ),

        //             // toolbar
        //             SizedBox(
        //               width: 400,
        //               child: Column(
        //                 children: [
        //                   ImageSizeSettings(),
        //                   Toolbar(),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),

        //       SizedBox(height: 32),

        //       // file overview
        //       SizedBox(
        //         width: double.infinity,
        //         child: SizedBox(
        //           height: 150,
        //           child: ProjectFileList(),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
