import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO(beau): this needs to include options for exporting, either
            // here or in a popup
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
