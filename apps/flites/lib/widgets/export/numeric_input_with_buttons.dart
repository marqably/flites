import 'dart:math';

import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class NumericInputWithButtons extends StatelessWidget {
  final String? label;
  final int currentValue;
  final ValueChanged<int> onChanged;

  const NumericInputWithButtons({
    super.key,
    this.label,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          gapH4,
        ],
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.onSurface),
            borderRadius: BorderRadius.circular(4),
            color: context.colors.surface,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: currentValue.toString(),
                    contentPadding: const EdgeInsets.only(left: 8),
                    border: InputBorder.none,
                    fillColor: context.colors.surface,
                    isDense: true,
                  ),
                  onChanged: (value) {
                    onChanged(int.tryParse(value) ?? 0);
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      onChanged(currentValue + 1);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 16,
                    color: context.colors.onSurface,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      onChanged(max(currentValue - 1, 0));
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 16,
                    color: context.colors.onSurface,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
