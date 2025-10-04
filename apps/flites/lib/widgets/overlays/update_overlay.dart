import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../../services/update_service.dart';
import '../../types/update_info.dart';
import 'base_dialog_card.dart';

final showUpdateOverlay = signal(false);
final updateOverlayInfo = signal<UpdateInfo?>(null);

class UpdateOverlay extends StatelessWidget {
  const UpdateOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    void showErrorSnackbar() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.failedToOpenUpdateUrl,
            style: TextStyle(
              color: context.colors.onSurface,
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        child: BaseDialogCard(
          backgroundColor: context.colors.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.system_update,
                size: 48,
                color: context.colors.primary,
              ),
              gapH16,
              Text(
                context.l10n.updateAvailable,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
              ),
              gapH8,
              Text(
                context.l10n.newVersionAvailable,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.onSurface,
                ),
              ),
              gapH4,
              Text(
                '${updateOverlayInfo.value?.currentVersion} → ${updateOverlayInfo.value?.newVersion}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.onSurface,
                ),
              ),
              gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => showUpdateOverlay.value = false,
                    child: Text(
                      context.l10n.later,
                      style: TextStyle(
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                  gapW8,
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.primary,
                    ),
                    onPressed: () async {
                      final updateLink = updateOverlayInfo.value?.updateLink;
                      if (updateLink == null) {
                        showErrorSnackbar();
                        return;
                      }
                      await UpdateService.openUpdateLink(updateLink);
                    },
                    child: Text(
                      context.l10n.updateNow,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
