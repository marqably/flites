import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';
import 'select_input.dart';

/// A multi-select input field with dropdown functionality
class SelectInputMulti<T> extends StatefulWidget {
  const SelectInputMulti({
    required this.options,
    required this.onChanged,
    super.key,
    this.selectedValues,
    this.prefix,
    this.suffix,
    this.postfixWidget,
    this.prefixWidget,
    this.label,
  });

  /// The list of selected values
  final List<T>? selectedValues;

  /// The list of options to display in the dropdown
  final List<SelectInputOption<T>> options;

  /// Callback when multiple values change
  final Function(List<T>) onChanged;

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

  @override
  State<SelectInputMulti<T>> createState() => _SelectInputMultiState<T>();
}

class _SelectInputMultiState<T> extends State<SelectInputMulti<T>> {
  late List<T> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.selectedValues?.toList() ?? [];
  }

  @override
  void didUpdateWidget(SelectInputMulti<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != oldWidget.selectedValues) {
      _selectedValues = widget.selectedValues?.toList() ?? [];
    }
  }

  /// Find option that matches a value
  SelectInputOption<T>? _findOptionByValue(T value) {
    try {
      return widget.options.firstWhere((option) => option.value == value);
    } on Exception {
      return null;
    }
  }

  /// Get the label for a value
  String _getLabelForValue(T value) {
    final option = _findOptionByValue(value);
    return option?.label ?? value.toString();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label if provided
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

          // Select field container
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.colors.surface),
            ),
            child: InkWell(
              onTap: _showMultiSelectDialog,
              child: Row(
                children: [
                  // prefix widget
                  if (widget.prefixWidget != null)
                    Flexible(flex: 0, child: widget.prefixWidget!),

                  // Prefix text
                  if (widget.prefix != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        widget.prefix!,
                        style: TextStyle(
                          color: context.colors.onSurface,
                          fontSize: fontSizeBase,
                        ),
                      ),
                    ),

                  // Selected values display
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      child: Text(
                        _selectedValues.isEmpty
                            ? context.l10n.selectOptionsPlaceholder
                            : _selectedValues.map(_getLabelForValue).join(', '),
                        style: TextStyle(
                          color: context.colors.onSurface,
                          fontSize: fontSizeBase,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Suffix text
                  if (widget.suffix != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        widget.suffix!,
                        style: TextStyle(
                          color: context.colors.onSurface,
                          fontSize: fontSizeBase,
                        ),
                      ),
                    ),

                  // Dropdown icon
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.colors.onSurface,
                  ),

                  // postfix widget
                  if (widget.postfixWidget != null)
                    Flexible(flex: 0, child: widget.postfixWidget!),
                ],
              ),
            ),
          ),
        ],
      );

  Future<void> _showMultiSelectDialog() async {
    // Create a temporary list for managing selection state
    // This ensures changes are only applied when the user confirms
    final List<T> tempSelectedValues = List.from(_selectedValues);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.l10n.selectOptionsTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.options
                  .map(
                    (option) => CheckboxListTile(
                      title: Text(option.label),
                      value: tempSelectedValues.contains(option.value),
                      onChanged: (selected) {
                        setState(() {
                          if (selected ?? false) {
                            tempSelectedValues.add(option.value);
                          } else {
                            tempSelectedValues.remove(option.value);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.l10n.cancel),
              onPressed: () {
                // Discard changes
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(context.l10n.ok),
              onPressed: () {
                // Update local state
                setState(() {
                  _selectedValues = tempSelectedValues;
                });

                // Apply changes and notify parent
                widget.onChanged(tempSelectedValues);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
