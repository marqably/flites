import 'package:flites/main.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flites/widgets/export/file_path_picker.dart';
import 'package:flites/widgets/export/numeric_input_with_buttons.dart';
import 'package:flites/widgets/export/padding_input.dart';
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

  int currentWidthPx = 300;
  int currentHeightPx = 300;

  int currentPaddingTop = 0;
  int currentPaddingBottom = 0;
  int currentPaddingLeft = 0;
  int currentPaddingRight = 0;

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
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: NumericInputWithButtons(
                    label: '${context.l10n.width} (px)',
                    currentValue: currentWidthPx,
                    onChanged: (value) {
                      setState(() {
                        currentWidthPx = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: NumericInputWithButtons(
                    label: '${context.l10n.height} (px)',
                    currentValue: currentHeightPx,
                    onChanged: (value) {
                      setState(() {
                        currentHeightPx = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PaddingInput(
              topPadding: currentPaddingTop,
              bottomPadding: currentPaddingBottom,
              leftPadding: currentPaddingLeft,
              rightPadding: currentPaddingRight,
              onTopChanged: (value) {
                setState(() {
                  currentPaddingTop = value;
                });
              },
              onBottomChanged: (value) {
                setState(() {
                  currentPaddingBottom = value;
                });
              },
              onLeftChanged: (value) {
                setState(() {
                  currentPaddingLeft = value;
                });
              },
              onRightChanged: (value) {
                setState(() {
                  currentPaddingRight = value;
                });
              },
            ),
            const SizedBox(height: 24),
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
                context.l10n.webDownloadLocation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: StadiumButton(
                text: context.l10n.export,
                onPressed: () {
                  double? width =
                      currentWidthPx > 0 ? currentWidthPx.toDouble() : null;
                  double? height =
                      currentHeightPx > 0 ? currentHeightPx.toDouble() : null;

                  if (width != null && height != null) {
                    // Both width and height are provided
                    GenerateSprite.exportSprite(
                      ExportSettings.sizeConstrained(
                        fileName: fileNameController.text,
                        path: exportPath,
                        widthPx: width,
                        heightPx: height,
                        paddingTopPx: currentPaddingTop.toDouble(),
                        paddingBottomPx: currentPaddingBottom.toDouble(),
                        paddingLeftPx: currentPaddingLeft.toDouble(),
                        paddingRightPx: currentPaddingRight.toDouble(),
                      ),
                    );
                  } else if (width != null) {
                    // Only width is provided
                    GenerateSprite.exportSprite(
                      ExportSettings.widthConstrained(
                        fileName: fileNameController.text,
                        path: exportPath,
                        widthPx: width,
                        paddingTopPx: currentPaddingTop.toDouble(),
                        paddingBottomPx: currentPaddingBottom.toDouble(),
                        paddingLeftPx: currentPaddingLeft.toDouble(),
                        paddingRightPx: currentPaddingRight.toDouble(),
                      ),
                    );
                  } else if (height != null) {
                    // Only height is provided
                    GenerateSprite.exportSprite(
                      ExportSettings.heightConstrained(
                        fileName: fileNameController.text,
                        path: exportPath,
                        heightPx: height,
                        paddingTopPx: currentPaddingTop.toDouble(),
                        paddingBottomPx: currentPaddingBottom.toDouble(),
                        paddingLeftPx: currentPaddingLeft.toDouble(),
                        paddingRightPx: currentPaddingRight.toDouble(),
                      ),
                    );
                  } else {
                    // Handle the case where neither width nor height is provided
                    // For example, show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.provideDimensionError),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
