import 'package:flites/main.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flites/widgets/export/file_path_picker.dart';
import 'package:flites/widgets/export/numeric_input_with_buttons.dart';
import 'package:flites/widgets/export/padding_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flites/constants/app_sizes.dart';
import 'package:signals/signals_flutter.dart';

class ExportDialogContent extends StatefulWidget {
  const ExportDialogContent({super.key});

  @override
  ExportDialogContentState createState() => ExportDialogContentState();
}

class ExportDialogContentState extends State<ExportDialogContent> {
  final fileNameController = TextEditingController(text: 'sprite');
  String? exportPath;

  // int currentWidthPx = 300;
  // int currentHeightPx = 0;

  // int currentPaddingTop = 0;
  // int currentPaddingBottom = 0;
  // int currentPaddingLeft = 0;
  // int currentPaddingRight = 0;

  // bool get _allImagesAreSvg {
  //   final images = projectSourceFiles.value.rows[selectedImageRow.value].images;
  //   if (images.isEmpty) return false;
  //   return images.every((image) => SvgUtils.isSvg(image.image));
  // }

  @override
  Widget build(BuildContext context) {
    Text buildLabelText(String text) {
      return Text(
        text,
        style: const TextStyle(fontSize: Sizes.p12),
      );
    }

    return Watch((context) {
      final selectedExportSettings =
          projectSourceFiles.value.rows[selectedImageRow.value].exportSettings;

      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p16,
          horizontal: Sizes.p16,
        ),
        margin: const EdgeInsets.only(bottom: Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelText(context.l10n.fileName.toUpperCase()),
            gapH8,
            SizedBox(
              height: 30,
              child: TextField(
                decoration: InputDecoration(
                  hintText: context.l10n.enterSpriteName,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  fillColor: context.colors.surface,
                  isDense: true,
                  filled: true,
                ),
                controller: fileNameController,
              ),
            ),
            gapH24,
            buildLabelText(context.l10n.sizePx),
            gapH16,
            Row(
              children: [
                buildLabelText(context.l10n.widthLabel),
                gapW4,
                Expanded(
                  child: NumericInputWithButtons(
                    currentValue: selectedExportSettings.widthPx,
                    onChanged: (value) {
                      SourceFilesState.changeExportSettings(
                        selectedImageRow.value,
                        selectedExportSettings.copyWith(widthPx: value),
                      );
                    },
                  ),
                ),
                gapW32,
                buildLabelText(context.l10n.heightLabel),
                gapW4,
                Expanded(
                  child: NumericInputWithButtons(
                    currentValue: selectedExportSettings.heightPx,
                    onChanged: (value) {
                      SourceFilesState.changeExportSettings(
                        selectedImageRow.value,
                        selectedExportSettings.copyWith(heightPx: value),
                      );
                    },
                  ),
                ),
              ],
            ),
            gapH24,
            PaddingInput(
              topPadding: selectedExportSettings.paddingTopPx,
              bottomPadding: selectedExportSettings.paddingBottomPx,
              leftPadding: selectedExportSettings.paddingLeftPx,
              rightPadding: selectedExportSettings.paddingRightPx,
              onTopChanged: (value) {
                SourceFilesState.changeExportSettings(
                  selectedImageRow.value,
                  selectedExportSettings.copyWith(paddingTopPx: value),
                );
              },
              onBottomChanged: (value) {
                SourceFilesState.changeExportSettings(
                  selectedImageRow.value,
                  selectedExportSettings.copyWith(paddingBottomPx: value),
                );
              },
              onLeftChanged: (value) {
                SourceFilesState.changeExportSettings(
                  selectedImageRow.value,
                  selectedExportSettings.copyWith(paddingLeftPx: value),
                );
              },
              onRightChanged: (value) {
                SourceFilesState.changeExportSettings(
                  selectedImageRow.value,
                  selectedExportSettings.copyWith(paddingRightPx: value),
                );
              },
            ),
            gapH24,
            if (!kIsWeb) ...[
              buildLabelText(context.l10n.location.toUpperCase()),
              gapH8,
              FilePathPicker(
                onPathSelected: (selectedPath) {
                  exportPath = selectedPath;
                },
              ),
              gapH48,
            ],
            if (kIsWeb) ...[
              buildLabelText(context.l10n.webDownloadLocation),
              gapH16,
            ],
            StadiumButton(
              text: context.l10n.export,
              onPressed: () {
                // double? width = selectedExportSettings.widthPx > 0
                //     ? selectedExportSettings.widthPx.toDouble()
                //     : null;
                // double? height = selectedExportSettings.heightPx > 0
                //     ? selectedExportSettings.heightPx.toDouble()
                //     : null;

                // // Prepare export settings based on the provided dimensions
                // ExportSettings? settings;
                // if (width != null && height != null) {
                //   // Both width and height are provided
                //   settings = ExportSettings.sizeConstrained(
                //     fileName: fileNameController.text,
                //     path: exportPath,
                //     widthPx: width,
                //     heightPx: height,
                //     paddingTopPx: currentPaddingTop.toDouble(),
                //     paddingBottomPx: currentPaddingBottom.toDouble(),
                //     paddingLeftPx: currentPaddingLeft.toDouble(),
                //     paddingRightPx: currentPaddingRight.toDouble(),
                //   );
                // } else if (width != null) {
                //   // Only width is provided
                //   settings = ExportSettings.widthConstrained(
                //     fileName: fileNameController.text,
                //     path: exportPath,
                //     widthPx: width,
                //     paddingTopPx: currentPaddingTop.toDouble(),
                //     paddingBottomPx: currentPaddingBottom.toDouble(),
                //     paddingLeftPx: currentPaddingLeft.toDouble(),
                //     paddingRightPx: currentPaddingRight.toDouble(),
                //   );
                // } else if (height != null) {
                //   // Only height is provided
                //   settings = ExportSettings.heightConstrained(
                //     fileName: fileNameController.text,
                //     path: exportPath,
                //     heightPx: height,
                //     paddingTopPx: currentPaddingTop.toDouble(),
                //     paddingBottomPx: currentPaddingBottom.toDouble(),
                //     paddingLeftPx: currentPaddingLeft.toDouble(),
                //     paddingRightPx: currentPaddingRight.toDouble(),
                //   );
                // }

                // if (settings != null) {
                //   // Use the appropriate generator based on image types
                //   if (_allImagesAreSvg) {
                //     GenerateSvgSprite.exportSpriteRow(
                //       settings,
                //       spriteRowIndex: selectedImageRow.value,
                //     );
                //   } else {
                //     GenerateSprite.exportSpriteRow(
                //       settings,
                //       spriteRowIndex: selectedImageRow.value,
                //     );
                //   }
                // } else {
                //   // Handle the case where neither width nor height is provided
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(context.l10n.provideDimensionError),
                //     ),
                //   );
                // }
              },
            ),
          ],
        ),
      );
    });
  }
}
