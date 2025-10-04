import 'package:flutter/material.dart';

import '../../inputs/number_input.dart';
import '../structure/panel_control_wrapper.dart';
import '../structure/panel_form.dart';

class PanelNumberInput extends StatelessWidget {
  const PanelNumberInput({
    required this.label,
    super.key,
    this.onChanged,
    this.value,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.helpText,
    this.formKey,
    this.inline = false,
  });
  final String label;
  final double? value;
  final double min;
  final double max;
  final double step;
  final Function(double)? onChanged;
  final String? helpText;

  /// The form key to integrate with PanelForm
  final String? formKey;

  /// If true, the input will be displayed inline without the PanelControlWrapper around it
  final bool? inline;

  @override
  Widget build(BuildContext context) {
    final formState = formKey != null ? PanelForm.of(context) : null;
    final currentValue = formKey != null
        ? formState?.getValue<double>(formKey!) ?? value
        : value;

    final inputWidget = NumberInput(
      label: label,
      value: currentValue ?? 0,
      onChanged: (newValue) {
        if (formKey != null) {
          formState?.setValue(formKey!, newValue);
        }

        onChanged?.call(newValue);
      },
      min: min,
      max: max,
      step: step,
    );

    if (inline ?? false) {
      return inputWidget;
    }

    return PanelControlWrapper(
      label: label,
      helpText: helpText,
      children: [
        inputWidget,
      ],
    );
  }
}
