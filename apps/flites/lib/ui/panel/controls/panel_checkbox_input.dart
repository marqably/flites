import 'package:flites/ui/inputs/checkbox_input.dart';
import 'package:flites/ui/panel/structure/panel_control_wrapper.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';
import 'package:flutter/material.dart';

/// A checkbox input control for use within panels
class PanelCheckboxInput extends StatefulWidget {
  /// Whether the checkbox is checked
  final bool value;

  /// Callback when the checkbox value changes
  final Function(bool)? onChanged;

  /// Text to display next to the checkbox
  final String? checkboxLabel;

  /// Label to display for the control
  final String label;

  /// Help text to display below the control
  final String? helpText;

  /// Additional widget to display after the checkbox
  final Widget? postfixWidget;

  /// Form key to identify this field in a PanelForm
  final String? formKey;

  const PanelCheckboxInput({
    super.key,
    required this.value,
    this.onChanged,
    this.checkboxLabel,
    required this.label,
    this.helpText,
    this.postfixWidget,
    this.formKey,
  }) : assert(
          formKey != null || onChanged != null,
          'Either formKey must be provided for form integration, or onChanged callback',
        );

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
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    // Get value from form if available
    bool value = widget.value;

    if (widget.formKey != null && _formState != null) {
      value = _formState!.getValue<bool>(widget.formKey!) ?? widget.value;
    }

    return PanelControlWrapper(
      label: widget.label,
      children: [
        CheckboxInput(
          isChecked: value,
          onChanged: _handleValueChanged,
          label: widget.checkboxLabel,
        ),
      ],
    );
  }
}
