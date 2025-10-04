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
    super.key,
    required this.child,
    this.onChanged,
    this.onSubmit,
    this.initialValues,
  });

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
  int _version = 0; // Version counter

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
      _version++; // Increment version
      // Pass an immutable copy to the callback
      widget.onChanged?.call(Map.unmodifiable(_formValues));
    });
  }

  /// Gets a single field value by key
  T? getValue<T>(String formKey) {
    // Check key existence for better type safety potential, though casting can still fail
    if (_formValues.containsKey(formKey) && _formValues[formKey] is T) {
      return _formValues[formKey] as T;
    }
    // Return null if key doesn't exist or type doesn't match
    return null;
  }

  /// Gets all form values
  Map<String, dynamic> getValues() {
    // Return an immutable copy
    return Map.unmodifiable(_formValues);
  }

  /// Submits the form
  void submit() {
    // Pass an immutable copy
    widget.onSubmit?.call(Map.unmodifiable(_formValues));
  }

  /// Resets the form to its initial values
  void reset() {
    setState(() {
      _formValues.clear();
      if (widget.initialValues != null) {
        _formValues.addAll(widget.initialValues!);
      }
      _version++; // Increment version
      // Pass an immutable copy
      widget.onChanged?.call(Map.unmodifiable(_formValues));
    });
  }

  // Expose version (needed for _PanelFormScope)
  int get version => _version;

  @override
  Widget build(BuildContext context) {
    return _PanelFormScope(
      formState: this,
      version: _version, // Pass version to scope
      child: widget.child,
    );
  }
}

/// InheritedWidget to provide form state to descendants
class _PanelFormScope extends InheritedWidget {
  final PanelFormState formState;
  final int version; // Add version

  const _PanelFormScope({
    required this.formState,
    required this.version, // Require version
    required super.child,
  });

  @override
  bool updateShouldNotify(_PanelFormScope old) =>
      version != old.version; // Compare version
}
