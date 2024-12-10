import 'package:flites/states/open_project.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../buttons/icon_text_button.dart';
import '../controls/checkbox_button.dart';
import '../controls/control_header.dart';
import '../image_editor/image_editor.dart';

final rotationSignal = signal<double?>(null);

class CanvasControls extends StatefulWidget {
  const CanvasControls({super.key});

  @override
  State<CanvasControls> createState() => _CanvasControlsState();
}

class _CanvasControlsState extends State<CanvasControls> {
  final rotationTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    rotationTextController.addListener(() {
      final angle = double.tryParse(rotationTextController.text);

      rotationSignal.value = angle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      padding: const EdgeInsets.all(16),
      child: Watch((context) {
        final currentImage = selectedImage;

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
            ControlHeader(text: 'Image Controls'),
            Text('Rotation'),
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: TextField(
                    controller: rotationTextController,
                    inputFormatters: [
                      // FilteringTextInputFormatter
                      //     ., // Allows only digits
                    ],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 32, 32, 32),
                    ),
                    decoration: InputDecoration(),
                  ),
                ),
                IconTextButton(
                  text: 'Save',
                  onPressed: () {},
                ),
              ],
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
