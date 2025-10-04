import 'package:flutter/material.dart';

import '../../inputs/text_input_field.dart';
import '../structure/panel_control_wrapper.dart';
import '../structure/panel_form.dart';

class PanelTextInput extends StatelessWidget {
  const PanelTextInput({
    required this.label,
    super.key,
    this.onChanged,
    this.value,
    this.helpText,
    this.formKey,
    this.inline = false,
  });
  final String label;
  final String? value;
  final Function(String)? onChanged;
  final String? helpText;

  /// The form key to integrate with PanelForm
  final String? formKey;

  /// If true, the input will be displayed inline without the PanelControlWrapper around it
  final bool? inline;

  @override
  Widget build(BuildContext context) {
    final formState = formKey != null ? PanelForm.of(context) : null;
    final currentValue = formKey != null
        ? formState?.getValue<String>(formKey!) ?? value
        : value;

    final inputWidget = TextInputField(
      value: currentValue ?? '',
      onChanged: (newValue) {
        if (formKey != null) {
          formState?.setValue(formKey!, newValue);
        }

        onChanged?.call(newValue);
      },
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
