import 'package:flites/constants/app_sizes.dart';
import 'package:flites/services/update_service.dart';
import 'package:flites/types/update_info.dart';
import 'package:flites/widgets/blocking_widget/blocking_container.dart';
import 'package:flites/widgets/image_editor/image_editor.dart';
import 'package:flites/widgets/overlays/update_overlay.dart';
import 'package:flites/widgets/project_file_list/project_file_list_vertical.dart';
import 'package:flites/widgets/tool_controls/tool_controls.dart';
import 'package:flites/widgets/tool_controls/zoom_controls.dart';
import 'package:flutter/foundation.dart';
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
    if (!kDebugMode) {
      Future.delayed(const Duration(seconds: 1), _checkForUpdates);
    }
  }

  Future<void> _checkForUpdates() async {
    final UpdateInfo? updateInfo = await UpdateService.checkForUpdates();
    final bool hasUpdate = updateInfo != null;

    if (hasUpdate && mounted) {
      showUpdateOverlay.value = true;
      updateOverlayInfo.value = updateInfo;
    }
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
                      right: Sizes.p32,
                      bottom: Sizes.p32,
                      child: ZoomControls(),
                    ),
                  ],
                ),
              ),
              ToolControls()
            ],
          ),
          BlockingContainer(),
          Positioned(
            bottom: Sizes.p64,
            child: PlayerControls(),
          ),
        ],
      ),
    );
  }
}
