import 'package:flutter/material.dart';

import '../inputs/slider_input.dart';

/// A slider with a number input for precise control
class SidebarSliderInput extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? suffix;
  final Function(double) onChanged;

  const SidebarSliderInput({
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
    return SliderInput(
      label: label,
      value: value,
      min: min,
      max: max,
      step: step,
      suffix: suffix,
      onChanged: onChanged,
    );
  }
}
