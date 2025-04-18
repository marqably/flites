import 'package:flites/ui/panel/panel.dart';
import 'package:flutter/material.dart';

class ExportToolPanel extends StatelessWidget {
  const ExportToolPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Panel(
      position: PanelPosition.right,
      children: [Text('Export tool sidebar')],
    );
  }
}
