import 'package:flutter/material.dart';

import '../../inputs/checkbox_input.dart';
import '../structure/panel_control_wrapper.dart';
import '../structure/panel_form.dart';

/// A checkbox input control for use within panels
class PanelCheckboxInput extends StatefulWidget {
  const PanelCheckboxInput({
    super.key,
    this.onChanged,
    this.checkboxLabel,
    this.label,
    this.formKey,
    this.helpText,
  }) : assert(
          formKey != null || onChanged != null,
          'Either formKey must be provided for form integration, or onChanged callback',
        );

  /// Callback when the checkbox value changes
  final Function({required bool value})? onChanged;

  /// Text to display next to the checkbox
  final String? checkboxLabel;

  /// Label to display for the control
  final String? label;

  /// Form key to identify this field in a PanelForm
  final String? formKey;

  /// Help text to display below the control
  final String? helpText;

  @override
  State<PanelCheckboxInput> createState() => _PanelCheckboxInputState();
}

class _PanelCheckboxInputState extends State<PanelCheckboxInput> {
  PanelFormState? _formState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get form state if available
    if (widget.formKey != null) {
      _formState = PanelForm.of(context);
    }
  }

  void _handleValueChanged(bool value) {
    // Update form state if in a form
    if (widget.formKey != null && _formState != null) {
      _formState!.setValue(widget.formKey!, value);
    }

    // Call direct callback if provided
    widget.onChanged?.call(value: value);
  }

  @override
  Widget build(BuildContext context) {
    final bool value;
    if (widget.formKey != null && _formState != null) {
      value = _formState!.getValue<bool>(widget.formKey!) ?? false;
    } else {
      value = false;
    }

    return PanelControlWrapper(
      label: widget.label,
      helpText: widget.helpText,
      children: [
        CheckboxInput(
          isChecked: value,
          onChanged: ({required value}) => _handleValueChanged(value),
          label: widget.checkboxLabel,
        ),
      ],
    );
  }
}
