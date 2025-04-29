import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A checkbox input field that matches the styling of other input components
class CheckboxInput extends StatelessWidget {
  /// Whether the checkbox is checked
  final bool isChecked;

  /// Callback when the checkbox value changes
  final Function(bool) onChanged;

  /// Text to display next to the checkbox
  final String? label;

  const CheckboxInput({
    super.key,
    required this.onChanged,
    this.label,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox
            Checkbox(
              value: isChecked,
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
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
                    height: 1.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
