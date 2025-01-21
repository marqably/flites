import 'package:flites/main.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flites/widgets/export/file_path_picker.dart';
import 'package:flutter/material.dart';

class ExportDialogContent extends StatefulWidget {
  const ExportDialogContent({super.key});

  @override
  _ExportDialogContentState createState() => _ExportDialogContentState();
}

class _ExportDialogContentState extends State<ExportDialogContent> {
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
              'Export Sprite',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'File name',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter sprite name',
                border: OutlineInputBorder(),
                fillColor: context.colors.surface,
                isDense: true,
                filled: true,
              ),
              controller: fileNameController,
            ),
            const SizedBox(height: 16),
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
            Align(
              alignment: Alignment.centerRight,
              child: StadiumButton(
                text: 'Export',
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
