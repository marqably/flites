import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

/// Represents an option in a radio input
class RadioInputOption<T> {
  /// Creates a radio input option
  const RadioInputOption({
    required this.label,
    required this.value,
    this.disabled = false,
    this.comment,
  });

  /// The display label for the option
  final String label;

  /// The underlying value for the option
  final T value;

  /// Whether the option is disabled
  final bool disabled;

  /// An optional comment to display below the option
  final String? comment;
}

/// A radio input field that matches the styling of other input components
class RadioInput<T> extends StatelessWidget {
  const RadioInput({
    required this.options,
    required this.onChanged,
    super.key,
    this.selectedValue,
    this.direction = Axis.vertical,
  });

  /// The currently selected value
  final T? selectedValue;

  /// The list of options to display as radio buttons
  final List<RadioInputOption<T>> options;

  /// Callback when the selected value changes
  final Function(T?) onChanged;

  /// Layout direction for the radio buttons (horizontal or vertical)
  final Axis direction;

  @override
  Widget build(BuildContext context) => Flex(
        direction: direction,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildRadioOptions(context),
      );

  List<Widget> _buildRadioOptions(BuildContext context) => options
      .map(
        (option) => GestureDetector(
          onTap: option.disabled ? null : () => onChanged(option.value),
          child: MouseRegion(
            cursor: option.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: Padding(
              padding: direction == Axis.horizontal
                  ? const EdgeInsets.only(right: Sizes.p16)
                  : const EdgeInsets.only(bottom: Sizes.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // radio
                      Radio<T>(
                        value: option.value,
                        groupValue: selectedValue,
                        onChanged: option.disabled ? null : onChanged,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      gapW8,

                      // label
                      Text(
                        option.label,
                        style: TextStyle(
                          color: option.disabled
                              ? Colors.grey
                              : context.colors.onSurface,
                          fontSize: fontSizeBase,
                        ),
                      ),
                    ],
                  ),
                  if (option.comment != null)
                    Text(
                      option.comment!,
                      style: TextStyle(
                        color: context.colors.onSurface.withValues(alpha: 0.7),
                        fontSize: fontSizeSm,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      )
      .toList();
}
