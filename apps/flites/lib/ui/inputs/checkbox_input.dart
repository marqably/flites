import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

/// A checkbox input field that matches the styling of other input components
class CheckboxInput extends StatelessWidget {
  const CheckboxInput({
    required this.onChanged,
    super.key,
    this.label,
    this.isChecked = false,
  });

  /// Whether the checkbox is checked
  final bool isChecked;

  /// Callback when the checkbox value changes
  final Function({required bool value}) onChanged;

  /// Text to display next to the checkbox
  final String? label;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(value: !isChecked),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isChecked,
                onChanged: (newValue) {
                  if (newValue != null) {
                    onChanged(value: newValue);
                  }
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),

              // Label
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: Sizes.p8),
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: context.colors.onSurface,
                      fontSize: fontSizeBase,
                      height: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
