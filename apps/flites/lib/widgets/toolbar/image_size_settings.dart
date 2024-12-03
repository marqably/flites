import 'package:flites/states/open_project.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ImageSizeSettings extends StatefulWidget {
  const ImageSizeSettings({super.key});

  @override
  State<ImageSizeSettings> createState() => _ImageSizeSettingsState();
}

class _ImageSizeSettingsState extends State<ImageSizeSettings> {
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  double get height => double.tryParse(heightController.text) ?? 0;
  double get width => double.tryParse(widthController.text) ?? 0;

  @override
  void initState() {
    super.initState();

    final currentSettings = outputSettings.value;

    widthController.text = currentSettings.itemWidth.toString();
    heightController.text = currentSettings.itemHeight.toString();

    // Update this widget if the controller changes to update the clickability
    // of the save button
    widthController.addListener(() {
      setState(() {});
    });

    heightController.addListener(() {
      setState(() {});
    });
  }

  bool get bothValuesValid => width > 0 && height > 0;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        final currentSettings = outputSettings.value;

        final unsavedChanges = currentSettings.itemWidth != width ||
            currentSettings.itemHeight != height;

        return Column(
          children: [
            const Text('Canvas Size'),
            Row(
              children: [
                const Text('Width:'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: widthController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Height:'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: heightController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: unsavedChanges && bothValuesValid
                  ? () {
                      outputSettings.value = currentSettings.copyWith(
                        itemWidth: width,
                        itemHeight: height,
                      );
                    }
                  : null,
              child: const Text(
                "Save Canvas Size",
              ),
            )
          ],
        );
      },
    );
  }
}
