import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A slider with a number input for precise control
class SliderInput extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? suffix;
  final Function(double) onChanged;

  const SliderInput({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: context.colors.onSurface,
        inactiveTrackColor: context.colors.onSurface,
        thumbColor: context.colors.onSurface,
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 11,
          elevation: 0,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: Sizes.p16,
        ),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: ((max - min) / step).round(),
        onChanged: onChanged,
      ),
    );
  }
}
