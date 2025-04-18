import 'package:flites/services/update_service.dart';
import 'package:flites/states/tool_controller.dart';
import 'package:flites/tools.dart';
import 'package:flites/types/update_info.dart';
import 'package:flites/widgets/overlays/update_overlay.dart';
import 'package:flites/widgets/right_click_menu/right_click_menu_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../states/key_events.dart';

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
    return Watch((context) {
      final selectedTool = toolController.selectedTool;

      return RightClickMenuHandler(
        child: Tools.getToolWidget(selectedTool),
      );
    });
  }
}
