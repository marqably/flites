import 'package:flites/ui/inputs/select_input.dart';
import 'package:flites/ui/inputs/select_input_multi.dart';
import 'package:flites/ui/panel/structure/panel_control_wrapper.dart';
import 'package:flites/ui/panel/structure/panel_form.dart';
import 'package:flutter/material.dart';

/// A select input control for use within panels
class PanelSelectInput<T> extends StatefulWidget {
  /// The currently selected value (for single selection mode)
  final T? value;

  /// The list of selected values (for multiple selection mode)
  final List<T>? selectedValues;

  /// The list of options to display in the dropdown
  final List<SelectInputOption<T>> options;

  /// Callback when value changes (for single selection mode)
  final Function(T?)? onChanged;

  /// Callback when multiple values change (for multiple selection mode)
  final Function(List<T>)? onMultiChanged;

  /// A prefix text to display before the select field
  final String? prefix;

  /// A suffix text to display after the select field
  final String? suffix;

  /// Widget to display after the select field, but still within the container
  final Widget? postfixWidget;

  /// Widget to display before the select field, but still within the container
  final Widget? prefixWidget;

  /// Label to display for the control
  final String label;

  /// Whether multiple selections are allowed
  final bool multiple;

  /// Help text to display below the control
  final String? helpText;

  /// Form key to identify this field in a PanelForm
  final String? formKey;

  const PanelSelectInput({
    super.key,
    this.value,
    this.selectedValues,
    required this.options,
    this.onChanged,
    this.onMultiChanged,
    this.prefix,
    this.suffix,
    this.postfixWidget,
    this.prefixWidget,
    required this.label,
    this.multiple = false,
    this.helpText,
    this.formKey,
  }) : assert(
          formKey != null ||
              ((multiple && onMultiChanged != null) ||
                  (!multiple && onChanged != null)),
          'Either formKey must be provided for form integration, or appropriate onChange callback',
        );

  @override
  State<PanelSelectInput<T>> createState() => _PanelSelectInputState<T>();
}

class _PanelSelectInputState<T> extends State<PanelSelectInput<T>> {
  PanelFormState? _formState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get form state if available
    if (widget.formKey != null) {
      _formState = PanelForm.of(context);
    }
  }

  void _handleSingleValueChanged(T? value) {
    // Update form state if in a form
    if (widget.formKey != null && _formState != null) {
      _formState!.setValue(widget.formKey!, value);
    }

    // Call direct callback if provided
    widget.onChanged?.call(value);
  }

  void _handleMultiValueChanged(List<T> values) {
    // Update form state if in a form
    if (widget.formKey != null && _formState != null) {
      _formState!.setValue(widget.formKey!, values);
    }

    // Call direct callback if provided
    widget.onMultiChanged?.call(values);
  }

  @override
  Widget build(BuildContext context) {
    // Get value from form if available
    T? singleValue = widget.value;
    List<T>? multiValues = widget.selectedValues;

    if (widget.formKey != null && _formState != null) {
      if (widget.multiple) {
        multiValues = _formState!.getValue<List<T>>(widget.formKey!) ??
            widget.selectedValues;
      } else {
        singleValue = _formState!.getValue<T>(widget.formKey!) ?? widget.value;
      }
    }

    return PanelControlWrapper(
      label: widget.label,
      helpText: widget.helpText,
      children: [
        widget.multiple
            ? _buildMultiSelect(multiValues)
            : _buildSingleSelect(singleValue),
      ],
    );
  }

  Widget _buildSingleSelect(T? value) {
    return SelectInput<T>(
      value: value,
      options: widget.options,
      onChanged: _handleSingleValueChanged,
      prefix: widget.prefix,
      suffix: widget.suffix,
      postfixWidget: widget.postfixWidget,
      prefixWidget: widget.prefixWidget,
    );
  }

  Widget _buildMultiSelect(List<T>? selectedValues) {
    return SelectInputMulti<T>(
      selectedValues: selectedValues,
      options: widget.options,
      onChanged: _handleMultiValueChanged,
      prefix: widget.prefix,
      suffix: widget.suffix,
      postfixWidget: widget.postfixWidget,
      prefixWidget: widget.prefixWidget,
    );
  }
}
