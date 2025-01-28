import 'package:flites/main.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flites/widgets/export/export_dialog_content.dart';
import 'package:flites/widgets/project_file_list/overlay_button.dart';
import 'package:flutter/material.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayButton(
      followerAnchor: Alignment.bottomRight,
      targetAnchor: Alignment.topRight,
      offset: const Offset(0, 50),
      buttonChild: StadiumButton(
        text: context.l10n.exportSprite,
      ),
      overlayContent: const ExportDialogContent(),
    );
  }
}
