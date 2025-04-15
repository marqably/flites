import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final rotationSignal = signal<double?>(null);

class ToolControls extends StatefulWidget {
  const ToolControls({
    super.key,
    required this.child,
  });

  @override
  State<ToolControls> createState() => _ToolControlsState();

  final Widget child;
}

class _ToolControlsState extends State<ToolControls> {
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
    final divider = Divider(
      color: context.colors.surfaceContainerLow,
      height: 1,
    );

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Sizes.p8),
          bottomRight: Radius.circular(Sizes.p8),
        ),
      ),
      width: 300,
      child: Watch((context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.child,
          ],
        );
      }),
    );
  }
}
