import 'dart:io';

import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/widgets/overlays/base_dialog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:signals/signals.dart';
import 'package:url_launcher/url_launcher.dart';

final showFileSaveConfirmDialog = signal<String?>(null);

class FileSaveConfirmDialog extends StatelessWidget {
  const FileSaveConfirmDialog({super.key});

  Future<void> _openContainingFolder(String filePath) async {
    String directoryPath = path.dirname(filePath);
    Uri uri;

    if (Platform.isWindows) {
      uri = Uri.file(directoryPath);
    } else {
      uri = Uri.file(directoryPath);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Error: Could not launch URL: $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BaseDialogCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.check_mark_circled,
              size: Sizes.p32,
              color: context.colors.primary,
            ),
            gapH8,
            const Text(
              'Image saved!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                _openContainingFolder(showFileSaveConfirmDialog.value!);
                showFileSaveConfirmDialog.value = null;
              },
              child: const Text('Show Containing Folder'),
            )
          ],
        ),
      ),
    );
  }
}
