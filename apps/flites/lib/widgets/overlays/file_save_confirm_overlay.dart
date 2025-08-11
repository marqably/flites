import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flites/widgets/overlays/base_dialog_card.dart';
import 'package:path/path.dart' as path;
import 'package:signals/signals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flites/l10n/gen_l10n/app_localizations.dart';

final showFileSaveConfirmDialog = signal<String?>(null);

class FileSaveConfirmDialog extends StatelessWidget {
  const FileSaveConfirmDialog({super.key});

  Future<void> _openContainingFolder(String filePath) async {
    String directoryPath = path.dirname(filePath);
    Uri uri;

    uri = Uri.file(directoryPath);

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
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: BaseDialogCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.check_mark_circled,
              size: Sizes.p32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.imageSaved,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final filePath = showFileSaveConfirmDialog.value;
                if (filePath != null) {
                  _openContainingFolder(filePath);
                }
                showFileSaveConfirmDialog.value = null;
              },
              child: Text(l10n.showContainingFolder),
            )
          ],
        ),
      ),
    );
  }
}
