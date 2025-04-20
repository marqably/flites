import 'package:flutter/material.dart';

/// A form widget that manages state for panel controls
class PanelForm extends StatefulWidget {
  /// The child widgets inside the form
  final Widget child;

  /// Callback when any value in the form changes
  final Function(Map<String, dynamic>)? onChanged;

  /// Callback when the form is submitted
  final Function(Map<String, dynamic>)? onSubmit;

  /// Initial values for the form fields
  final Map<String, dynamic>? initialValues;

  const PanelForm({
    Key? key,
    required this.child,
    this.onChanged,
    this.onSubmit,
    this.initialValues,
  }) : super(key: key);

  @override
  PanelFormState createState() => PanelFormState();

  /// Static method to get the form state from context
  static PanelFormState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PanelFormScope>()
        ?.formState;
  }
}

class PanelFormState extends State<PanelForm> {
  /// Map of form field values indexed by their formKey
  final Map<String, dynamic> _formValues = {};

  @override
  void initState() {
    super.initState();

    // Initialize with the provided initial values
    if (widget.initialValues != null) {
      _formValues.addAll(widget.initialValues!);
    }
  }

  /// Updates a single field value
  void setValue(String formKey, dynamic value) {
    setState(() {
      _formValues[formKey] = value;
      widget.onChanged?.call(_formValues);
    });
  }

  /// Gets a single field value by key
  T? getValue<T>(String formKey) {
    return _formValues[formKey] as T?;
  }

  /// Gets all form values
  Map<String, dynamic> getValues() {
    return Map.unmodifiable(_formValues);
  }

  /// Submits the form
  void submit() {
    widget.onSubmit?.call(_formValues);
  }

  /// Resets the form to its initial values
  void reset() {
    setState(() {
      _formValues.clear();
      if (widget.initialValues != null) {
        _formValues.addAll(widget.initialValues!);
      }
      widget.onChanged?.call(_formValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PanelFormScope(
      formState: this,
      child: widget.child,
    );
  }
}

/// InheritedWidget to provide form state to descendants
class _PanelFormScope extends InheritedWidget {
  final PanelFormState formState;

  const _PanelFormScope({
    required this.formState,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_PanelFormScope old) => formState != old.formState;
}
