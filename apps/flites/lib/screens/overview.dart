import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../config/tools.dart';
import '../services/update_service.dart';
import '../states/key_events.dart';
import '../states/tool_controller.dart';
import '../types/update_info.dart';
import '../widgets/overlays/update_overlay.dart';
import '../widgets/right_click_menu/right_click_menu_handler.dart';

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
  Widget build(BuildContext context) => Watch((context) {
        final selectedTool = toolController.selectedTool;

        return RightClickMenuHandler(
          child: getToolWidget(selectedTool),
        );
      });
}
