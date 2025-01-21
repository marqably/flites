import 'package:flites/main.dart';
import 'package:flites/widgets/export/export_button.dart';
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
      color: context.colors.surfaceContainerLowest,
      width: 300,
      padding: const EdgeInsets.all(16),
      child: Watch((context) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Center(child: ExportButton()),
          ],
        );
      }),
    );
  }
}
