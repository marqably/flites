import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// Represents an option in a select input
class SelectInputOption<T> {
  /// The display label for the option
  final String label;

  /// The underlying value for the option
  final T value;

  /// Whether the option is disabled
  final bool disabled;

  /// An optional comment to display below the option
  final String? comment;

  /// Creates a select input option
  const SelectInputOption({
    required this.label,
    required this.value,
    this.disabled = false,
    this.comment,
  });
}

/// A select input field with dropdown functionality that matches InputField styling
class SelectInput<T> extends StatelessWidget {
  /// The currently selected value
  final T? value;

  /// The list of options to display in the dropdown
  final List<SelectInputOption<T>> options;

  /// Callback when value changes
  final Function(T?) onChanged;

  /// A prefix text to display before the select field
  final String? prefix;

  /// A suffix text to display after the select field
  final String? suffix;

  /// Widget to display after the select field, but still within the container
  final Widget? postfixWidget;

  /// Widget to display before the select field, but still within the container
  final Widget? prefixWidget;

  /// Optional label to display above the select field
  final String? label;

  const SelectInput({
    super.key,
    this.value,
    required this.options,
    required this.onChanged,
    this.prefix,
    this.suffix,
    this.postfixWidget,
    this.prefixWidget,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label if provided
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

        // Select field container
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: context.colors.surface),
          ),
          child: _buildSingleSelect(context),
        ),
      ],
    );
  }

  Widget _buildSingleSelect(BuildContext context) {
    return Row(
      children: [
        // prefix widget
        if (prefixWidget != null) Flexible(flex: 0, child: prefixWidget!),

        // Prefix text
        if (prefix != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              prefix!,
              style: TextStyle(
                color: context.colors.onSurface,
                fontSize: fontSizeBase,
              ),
            ),
          ),

        // Dropdown
        Expanded(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: context.colors.onSurface,
              ),
              style: TextStyle(
                color: context.colors.onSurface,
                fontSize: fontSizeBase,
                height: 1.0,
              ),
              onChanged: onChanged,
              items: options
                  .map<DropdownMenuItem<T>>(
                      (option) => _buildDropdownMenuItem(context, option))
                  .toList(),
            ),
          ),
        ),

        // Suffix text
        if (suffix != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              suffix!,
              style: TextStyle(
                color: context.colors.onSurface,
                fontSize: fontSizeBase,
              ),
            ),
          ),

        // postfix widget
        if (postfixWidget != null) Flexible(flex: 0, child: postfixWidget!),
      ],
    );
  }

  DropdownMenuItem<T> _buildDropdownMenuItem(
      BuildContext context, SelectInputOption<T> option) {
    return DropdownMenuItem<T>(
      value: option.disabled ? null : option.value,
      enabled: !option.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // label
          Text(
            option.label,
            style: TextStyle(
              color: context.colors.onSurface
                  .withValues(alpha: option.disabled ? 0.5 : 1),
              fontSize: fontSizeBase,
            ),
          ),

          // disabled comment
          if (option.comment != null)
            Padding(
              padding: const EdgeInsets.only(top: Sizes.p4),
              child: Text(
                option.comment!,
                style: TextStyle(
                  color: context.colors.error
                      .withValues(alpha: option.disabled ? 0.5 : 1),
                  fontSize: fontSizeSm,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
