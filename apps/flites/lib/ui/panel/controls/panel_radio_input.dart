import 'package:flutter/material.dart';

import '../../inputs/radio_input.dart';
import '../structure/panel_control_wrapper.dart';
import '../structure/panel_form.dart';

/// A radio input control for use within panels
class PanelRadioInput<T> extends StatefulWidget {
  const PanelRadioInput({
    required this.options,
    required this.label,
    super.key,
    this.selectedValue,
    this.onChanged,
    this.direction = Axis.vertical,
    this.formKey,
    this.helpText,
  }) : assert(
          formKey != null || onChanged != null,
          'Either formKey must be provided for form integration, or onChanged callback',
        );

  /// The currently selected value
  final T? selectedValue;

  /// The list of options to display as radio buttons
  final List<RadioInputOption<T>> options;

  /// Callback when the selected value changes
  final Function(T?)? onChanged;

  /// Label to display for the control
  final String label;

  /// Layout direction for the radio buttons (horizontal or vertical)
  final Axis direction;

  /// Form key to identify this field in a PanelForm
  final String? formKey;

  /// Help text to display below the control
  final String? helpText;

  @override
  State<PanelRadioInput<T>> createState() => _PanelRadioInputState<T>();
}

class _PanelRadioInputState<T> extends State<PanelRadioInput<T>> {
  PanelFormState? _formState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get form state if available
    if (widget.formKey != null) {
      _formState = PanelForm.of(context);
    }
  }

  void _handleValueChanged(T? value) {
    // Update form state if in a form
    if (widget.formKey != null && _formState != null) {
      _formState!.setValue(widget.formKey!, value);
    }

    // Call direct callback if provided
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    // Get value from form if available
    T? selectedValue = widget.selectedValue;

    if (widget.formKey != null && _formState != null) {
      selectedValue =
          _formState!.getValue<T>(widget.formKey!) ?? widget.selectedValue;
    }

    return PanelControlWrapper(
      label: widget.label,
      helpText: widget.helpText,
      children: [
        RadioInput<T>(
          selectedValue: selectedValue,
          options: widget.options,
          onChanged: _handleValueChanged,
          direction: widget.direction,
        ),
      ],
    );
  }
}
