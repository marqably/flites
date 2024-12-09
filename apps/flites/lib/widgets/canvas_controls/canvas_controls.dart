import 'package:flites/states/open_project.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../buttons/icon_text_button.dart';
import '../controls/checkbox_button.dart';
import '../controls/control_header.dart';
import '../image_editor/image_editor.dart';

class CanvasControls extends StatelessWidget {
  const CanvasControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      padding: const EdgeInsets.all(16),
      child: Watch((context) {
        final currentImage = getCurrentSingularSelection();

        print('currentImage: $currentImage');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControlHeader(text: 'Canvas Controls'),
            CheckboxButton(
              text: 'Use Previos Frame as Reference',
              value: usePreviousImageAsReference,
            ),
            CheckboxButton(
              text: 'Show bounding border',
              value: showBoundingBorderSignal,
            ),

            const SizedBox(height: 32),
            // if (projectSourceFiles.value.length > 1) ...[
            ControlHeader(text: 'Image Controls'),
            IconTextButton(
              onPressed: () {
                final images = [...projectSourceFiles.value];

                images.sort((a, b) {
                  if (a.displayName != null && b.displayName != null) {
                    return a.displayName!.compareTo(b.displayName!);
                  }

                  return 0;
                });

                projectSourceFiles.value = images;
              },
              text: 'Sort by name',
            ),
            IconTextButton(
              onPressed: () {
                final images = [...projectSourceFiles.value];

                for (int i = 1; i <= images.length; i++) {
                  final img = images[i - 1];
                  img.displayName = 'frame_$i.png';
                }

                projectSourceFiles.value = images;
              },
              text: 'Rename Files according to order',
            ),
            IconTextButton(
              onPressed: () {
                final images = [...projectSourceFiles.value];

                for (int i = 1; i <= images.length; i++) {
                  final img = images[i - 1];
                  img.displayName = img.originalName;
                }

                projectSourceFiles.value = images;
              },
              text: 'Reset Names',
            ),
            // ],
            const Spacer(),
            // const Divider(),
            // const SizedBox(
            //   height: 200,
            //   child: Text('Export Settings'),
            // ),
            Center(
              child: StadiumButton(
                text: 'Export Sprite',
                onPressed: () {
                  GenerateSprite.exportSprite(
                      ExportSettings.widthConstrained(widthPx: 620));
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
