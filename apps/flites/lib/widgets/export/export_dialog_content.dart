import 'package:flites/main.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/generate_svg_sprite.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flites/widgets/export/file_path_picker.dart';
import 'package:flites/widgets/export/numeric_input_with_buttons.dart';
import 'package:flites/widgets/export/padding_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flites/constants/app_sizes.dart';

class ExportDialogContent extends StatefulWidget {
  const ExportDialogContent({super.key});

  @override
  ExportDialogContentState createState() => ExportDialogContentState();
}

class ExportDialogContentState extends State<ExportDialogContent> {
  final fileNameController = TextEditingController(text: 'sprite');
  String? exportPath;

  int currentWidthPx = 300;
  int currentHeightPx = 0;

  int currentPaddingTop = 0;
  int currentPaddingBottom = 0;
  int currentPaddingLeft = 0;
  int currentPaddingRight = 0;

  bool get _allImagesAreSvg {
    final images = projectSourceFiles.value;
    if (images.isEmpty) return false;
    return images.every((image) => SvgUtils.isSvg(image.image));
  }

  String get _outputFormatText {
    return _allImagesAreSvg ? 'SVG' : 'PNG';
  }

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
            gapH24,
            Text(
              context.l10n.fileName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            gapH8,
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
            gapH24,
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
                gapW8,
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
            gapH24,
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
            gapH24,
            if (!kIsWeb) ...[
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              gapH8,
              FilePathPicker(
                onPathSelected: (selectedPath) {
                  exportPath = selectedPath;
                },
              ),
              gapH24,
            ],
            if (kIsWeb) ...[
              Text(
                context.l10n.webDownloadLocation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              gapH16,
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Output format indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _allImagesAreSvg ? Icons.photo : Icons.image,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Output: ${_outputFormatText}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                StadiumButton(
                  text: context.l10n.export,
                  onPressed: () {
                    double? width =
                        currentWidthPx > 0 ? currentWidthPx.toDouble() : null;
                    double? height =
                        currentHeightPx > 0 ? currentHeightPx.toDouble() : null;

                    // Prepare export settings based on the provided dimensions
                    ExportSettings? settings;
                    if (width != null && height != null) {
                      // Both width and height are provided
                      settings = ExportSettings.sizeConstrained(
                        fileName: fileNameController.text,
                        path: exportPath,
                        widthPx: width,
                        heightPx: height,
                        paddingTopPx: currentPaddingTop.toDouble(),
                        paddingBottomPx: currentPaddingBottom.toDouble(),
                        paddingLeftPx: currentPaddingLeft.toDouble(),
                        paddingRightPx: currentPaddingRight.toDouble(),
                      );
                    } else if (width != null) {
                      // Only width is provided
                      settings = ExportSettings.widthConstrained(
                        fileName: fileNameController.text,
                        path: exportPath,
                        widthPx: width,
                        paddingTopPx: currentPaddingTop.toDouble(),
                        paddingBottomPx: currentPaddingBottom.toDouble(),
                        paddingLeftPx: currentPaddingLeft.toDouble(),
                        paddingRightPx: currentPaddingRight.toDouble(),
                      );
                    } else if (height != null) {
                      // Only height is provided
                      settings = ExportSettings.heightConstrained(
                        fileName: fileNameController.text,
                        path: exportPath,
                        heightPx: height,
                        paddingTopPx: currentPaddingTop.toDouble(),
                        paddingBottomPx: currentPaddingBottom.toDouble(),
                        paddingLeftPx: currentPaddingLeft.toDouble(),
                        paddingRightPx: currentPaddingRight.toDouble(),
                      );
                    }

                    if (settings != null) {
                      // Use the appropriate generator based on image types
                      if (_allImagesAreSvg) {
                        GenerateSvgSprite.exportSprite(settings);
                      } else {
                        GenerateSprite.exportSprite(settings);
                      }
                    } else {
                      // Handle the case where neither width nor height is provided
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.provideDimensionError),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
