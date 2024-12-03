import 'package:flites/states/open_project.dart';
import 'package:flites/utils/get_flite_image.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../controls/checkbox_button.dart';

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
              text: 'Enable Scaling',
              value: enableScaling,
            ),
            CheckboxButton(
              text: 'Use Previos Frame as Reference',
              value: usePreviousImageAsReference,
            ),
            if (currentImage != null)
              ElevatedButton(
                onPressed: currentImage.originalScalingFactor != null &&
                        !currentImage.isAtOriginalSize
                    ? () {
                        currentImage.resetScaling();
                      }
                    : null,
                child: const Text('Reset to original scaling'),
              ),
            if (projectSourceFiles.value.length > 1)
              ElevatedButton(
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
          ],
        );
      }),
    );
  }
}
