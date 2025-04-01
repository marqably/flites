import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({
    super.key,
    required this.currentVersion,
    required this.newVersion,
  });

  final String currentVersion;
  final String newVersion;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
        ),
        width: 300,
        padding: const EdgeInsets.all(16.0),
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
              'Update Available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            gapH8,
            Text(
              'A new version of Flites is available.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.onSurface,
              ),
            ),
            gapH4,
            Text(
              '$currentVersion → $newVersion',
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
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Later',
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
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Update Now',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
