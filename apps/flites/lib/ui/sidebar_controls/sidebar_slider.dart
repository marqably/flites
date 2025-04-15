import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A slider with a number input for precise control
class SidebarSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String? suffix;
  final Function(double) onChanged;

  const SidebarSlider({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.onSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              // Slider
              Expanded(
                flex: 3,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: context.colors.primary,
                    inactiveTrackColor: context.colors.secondary,
                    thumbColor: context.colors.primary,
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                      elevation: 0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                  ),
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: ((max - min) / step).round(),
                    onChanged: onChanged,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Number input
              Expanded(
                flex: 2,
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller:
                              TextEditingController(text: value.toString()),
                          style: TextStyle(
                            color: context.colors.onPrimary,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            border: InputBorder.none,
                            suffix: suffix != null
                                ? Text(
                                    suffix!,
                                    style: TextStyle(
                                      color: context.colors.onSecondary,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                          ),
                          onSubmitted: (newValue) {
                            final parsedValue = double.tryParse(newValue);
                            if (parsedValue != null) {
                              onChanged(parsedValue.clamp(min, max));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
