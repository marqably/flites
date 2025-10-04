import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import '../../states/selected_image_row_state.dart';
import '../../states/source_files_state.dart';
import '../buttons/stadium_button.dart';
import 'file_path_picker.dart';
import 'numeric_input_with_buttons.dart';
import 'padding_input.dart';

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
    Text buildLabelText(String text) => Text(
          text,
          style: const TextStyle(fontSize: Sizes.p12),
        );

    return Watch((context) {
      final selectedExportSettings =
          SourceFilesState.projectSourceFiles
          .rows[SelectedImageRowState.selectedImageRow].exportSettings;

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
            buildLabelText(context.l10n.sizePx),
            gapH16,
            Row(
              children: [
                buildLabelText(context.l10n.widthLabel),
                gapW4,
                Expanded(
                  child: NumericInputWithButtons(
                    currentValue: selectedExportSettings.widthPx ?? 0,
                    onChanged: (value) {
                      SourceFilesState.changeExportSettings(
                        SelectedImageRowState.selectedImageRow,
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
                    currentValue: selectedExportSettings.heightPx ?? 0,
                    onChanged: (value) {
                      SourceFilesState.changeExportSettings(
                        SelectedImageRowState.selectedImageRow,
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
                  SelectedImageRowState.selectedImageRow,
                  selectedExportSettings.copyWith(paddingTopPx: value),
                );
              },
              onBottomChanged: (value) {
                SourceFilesState.changeExportSettings(
                  SelectedImageRowState.selectedImageRow,
                  selectedExportSettings.copyWith(paddingBottomPx: value),
                );
              },
              onLeftChanged: (value) {
                SourceFilesState.changeExportSettings(
                  SelectedImageRowState.selectedImageRow,
                  selectedExportSettings.copyWith(paddingLeftPx: value),
                );
              },
              onRightChanged: (value) {
                SourceFilesState.changeExportSettings(
                  SelectedImageRowState.selectedImageRow,
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
              onPressed: () {},
            ),
          ],
        ),
      );
    });
  }
}
