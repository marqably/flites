import 'package:flites/tools/export_tool/export_tool_panel.dart';
import 'package:flites/widgets/layout/app_shell.dart';
import 'package:flutter/material.dart';

/// Displays a screen to prepare the export of our sprite map
class ExportTool extends StatelessWidget {
  const ExportTool({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      panelLeft: null,
      spriteMapBar: false,
      panelRight: ExportToolPanel(
          // onExport: (options) {
          //   print(options);
          // },
          ),
      child: Container(
          height: double.infinity,
          color: Colors.red,
          child: const Text('Export tool')),
    );
  }
}
