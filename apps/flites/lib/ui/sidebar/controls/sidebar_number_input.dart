import 'package:flites/ui/sidebar/inputs/number_input.dart';
import 'package:flites/ui/sidebar/structure/sidebar_control_wrapper.dart';
import 'package:flutter/material.dart';

class SidebarNumberInput extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final Function(double) onChanged;

  const SidebarNumberInput({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarControlWrapper(
      label: label,
      children: [
        NumberInput(
          label: label,
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          step: step,
        ),
      ],
    );
  }
}
