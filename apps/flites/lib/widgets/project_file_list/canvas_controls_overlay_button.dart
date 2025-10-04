import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../constants/app_sizes.dart';
import '../../core/app_state.dart';
import '../../main.dart';
import '../../states/open_project.dart';
import '../../states/source_files_state.dart';
import '../buttons/icon_text_button.dart';
import '../controls/checkbox_button.dart';
import 'overlay_button.dart';

class CanvasControlsButton extends StatelessWidget {
  const CanvasControlsButton({super.key});

  @override
  Widget build(BuildContext context) => OverlayButton(
        tooltip: context.l10n.canvasAndImageControls,
        offset: const Offset(0, -12),
        buttonChild: Container(
          padding: const EdgeInsets.all(Sizes.p8),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(Sizes.p8),
          ),
          child: Icon(
            CupertinoIcons.layers,
            color: context.colors.onSurface,
          ),
        ),
        overlayContent: (close) => Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.canvasControls,
                  style: const TextStyle(fontSize: 16),
                ),
                gapH16,
                CheckboxButton(
                  text: context.l10n.usePreviousFrameAsReference,
                  value: usePreviousImageAsReference,
                ),
                Watch(
                  (context) {
                    final isChecked = appState.showBoundingBorder.value;
                    return InkWell(
                      onTap: appState.toggleBoundingBorder,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              isChecked
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: context.colors.onSurface,
                            ),
                            gapW8,
                            Expanded(
                              child: Text(
                                context.l10n.showBoundingBorder,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                gapH16,
                IconTextButton(
                  onPressed: SourceFilesState.sortImagesByName,
                  text: context.l10n.sortByName,
                ),
                gapH8,
                IconTextButton(
                  onPressed: SourceFilesState.renameImagesAccordingToOrder,
                  text: context.l10n.renameFilesAccordingToOrder,
                ),
                gapH8,
                IconTextButton(
                  onPressed: SourceFilesState.resetImageNamesToOriginal,
                  text: context.l10n.resetNames,
                ),
              ],
            ),
          ),
        ),
      );
}
