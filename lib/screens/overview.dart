import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flites/widgets/toolbar/image_size_settings.dart';
import 'package:flutter/material.dart';
import '../widgets/project_file_list/project_file_list.dart';
import '../widgets/toolbar/toolbar.dart';
import '../widgets/upload_area/file_drop_area.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // main interface
        Expanded(
          child: Row(
            children: [
              // image editor
              Expanded(
                flex: 3,
                child: ImageEditor(),
              ),

              // toolbar
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    ImageSizeSettings(),
                    Toolbar(),
                  ],
                ),
              ),
            ],
          ),
        ),

        // file overview
        SizedBox(
          width: double.infinity,
          child: FileDropArea(
            child: SizedBox(height: 150, child: ProjectFileList()),
          ),
        ),
      ],
    );
  }
}
