import 'package:flites/main.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flites/widgets/export/file_path_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExportDialogContent extends StatefulWidget {
  const ExportDialogContent({super.key});

  @override
  ExportDialogContentState createState() => ExportDialogContentState();
}

class ExportDialogContentState extends State<ExportDialogContent> {
  final fileNameController = TextEditingController(text: 'sprite');
  String? exportPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.exportSprite,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.fileName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: context.l10n.enterSpriteName,
                border: const OutlineInputBorder(),
                fillColor: context.colors.surface,
                isDense: true,
                filled: true,
              ),
              controller: fileNameController,
            ),
            const SizedBox(height: 16),
            if (!kIsWeb) ...[
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              FilePathPicker(
                onPathSelected: (selectedPath) {
                  exportPath = selectedPath;
                },
              ),
              const SizedBox(height: 24),
            ],
            if (kIsWeb) ...[
              Text(
                'File will be saved to your downloads folder.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: StadiumButton(
                text: context.l10n.export,
                onPressed: () {
                  GenerateSprite.exportSprite(
                    ExportSettings.widthConstrained(
                      fileName: fileNameController.text,
                      path: exportPath,
                      widthPx: 620,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
