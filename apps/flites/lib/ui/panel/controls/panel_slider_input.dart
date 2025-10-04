import 'package:flutter/material.dart';

import '../../inputs/number_input.dart';
import '../../inputs/slider_input.dart';
import '../structure/panel_control_wrapper.dart';

/// A slider with a number input for precise control
class PanelSliderInput extends StatelessWidget {
  const PanelSliderInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.suffix,
    this.helpText,
  });
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? suffix;
  final Function(double) onChanged;
  final String? helpText;

  @override
  Widget build(BuildContext context) => PanelControlWrapper(
        label: label,
        helpText: helpText,
        layout: PanelControlWrapperLayout.bigSmall,
        children: [
          // Slider
          SliderInput(
            label: label,
            value: value,
            min: min,
            max: max,
            step: step,
            suffix: suffix,
            onChanged: onChanged,
          ),

          // Number input
          NumberInput(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            step: step,
          ),
        ],
      );
}
