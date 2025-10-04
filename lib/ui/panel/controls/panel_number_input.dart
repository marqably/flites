import 'package:flites/ui/inputs/number_input.dart';
import 'package:flites/ui/panel/structure/panel_control_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';

class PanelNumberInput extends StatelessWidget {
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

  const PanelNumberInput({
    super.key,
    required this.label,
    this.onChanged,
    this.value,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.helpText,
    this.formKey,
    this.inline = false,
  });

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

    if (inline == true) {
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
