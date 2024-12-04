import 'package:file_picker/file_picker.dart';
import 'package:flites/states/open_project.dart';
import 'package:flites/types/flites_image.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flites/utils/image_utils.dart';
import 'package:flites/widgets/upload_area/file_drop_area.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../controls/checkbox_button.dart';
import '../image_editor/image_editor.dart';

class CanvasControls extends StatelessWidget {
  const CanvasControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      child: Watch((context) {
        final currentImage = getCurrentSingularSelection();

        print('currentImage: $currentImage');

        return Column(
          children: [
            CheckboxButton(
              text: 'Use Previos Frame as Reference',
              value: usePreviousImageAsReference,
            ),
            CheckboxButton(
              text: 'Show bounding border',
              value: showBoundingBorderSignal,
            ),
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  withData: true,
                  type: FileType.custom,
                  allowedExtensions: ['png'],
                );

                if (result == null) {
                  return;
                }

                final imagesAndNames = (await Future.wait(
                        result.files.map(ImageUtils.rawImageFroMPlatformFile)))
                    .whereType<RawImageAndName>()
                    .where((e) => e.image != null && isPng(e.image!))
                    .toList();

                if (imagesAndNames.isNotEmpty) {
                  final scalingFactor =
                      ImageUtils.getScalingFactorForMultipleImages(
                    images: imagesAndNames.map((e) => e.image!).toList(),
                    sizeLongestSideOnCanvas: defaultSizeOnCanvas,
                  );

                  imagesAndNames.sort((a, b) {
                    if (a.name != null && b.name != null) {
                      return a.name!.compareTo(b.name!);
                    }

                    print('### 1');

                    return 0;
                  });

                  print('### 2');

                  for (final img in imagesAndNames) {
                    final flitesImage = FlitesImage.scaled(img.image!,
                        scalingFactor: scalingFactor, name: img.name);

                    projectSourceFiles.value = [
                      ...projectSourceFiles.value,
                      flitesImage,
                    ];
                  }
                }
              },
              child: const Text('Import Files'),
            ),

            // if (currentImage != null)
            //   TextButton(
            //     onPressed: currentImage.originalScalingFactor != null &&
            //             !currentImage.isAtOriginalSize
            //         ? () {
            //             currentImage.resetScaling();
            //           }
            //         : null,
            //     child: const Text('Reset to original scaling'),
            //   ),
            if (projectSourceFiles.value.length > 1)
              TextButton(
                onPressed: () {
                  final images = [...projectSourceFiles.value];

                  images.sort((a, b) {
                    if (a.name != null && b.name != null) {
                      return a.name!.compareTo(b.name!);
                    }

                    return 0;
                  });

                  projectSourceFiles.value = images;
                },
                child: const Text('Order by name'),
              ),
            const Spacer(),
            const Divider(),
            const SizedBox(
              height: 200,
              child: Text('Export Settings'),
            ),
            TextButton(
              onPressed: () {
                GenerateSprite.exportSprite(
                    ExportSettings.widthConstrained(widthPx: 620));
              },
              child: const Text('Export Image'),
            ),
          ],
        );
      }),
    );
  }
}
