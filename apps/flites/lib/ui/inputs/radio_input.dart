import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// Represents an option in a radio input
class RadioInputOption<T> {
  /// The display label for the option
  final String label;

  /// The underlying value for the option
  final T value;

  /// Creates a radio input option
  const RadioInputOption({
    required this.label,
    required this.value,
  });
}

/// A radio input field that matches the styling of other input components
class RadioInput<T> extends StatelessWidget {
  /// The currently selected value
  final T? selectedValue;

  /// The list of options to display as radio buttons
  final List<RadioInputOption<T>> options;

  /// Callback when the selected value changes
  final Function(T?) onChanged;

  /// Layout direction for the radio buttons (horizontal or vertical)
  final Axis direction;

  const RadioInput({
    super.key,
    this.selectedValue,
    required this.options,
    required this.onChanged,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildRadioOptions(context),
    );
  }

  List<Widget> _buildRadioOptions(BuildContext context) {
    return options.map((option) {
      return GestureDetector(
        onTap: () => onChanged(option.value),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: direction == Axis.horizontal
                ? const EdgeInsets.only(right: Sizes.p16)
                : const EdgeInsets.only(bottom: Sizes.p8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // radio
                Radio<T>(
                  value: option.value,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                gapW8,

                // label
                Text(
                  option.label,
                  style: TextStyle(
                    color: context.colors.onSurface,
                    fontSize: fontSizeBase,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
