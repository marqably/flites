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
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.p4),
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
                    hintStyle: TextStyle(
                      color: context.colors.onSurface,
                    ),
                    contentPadding: const EdgeInsets.only(left: Sizes.p8),
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
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Sizes.p4),
                        topRight: Radius.circular(Sizes.p4),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_drop_up),
                      onPressed: () {
                        onChanged(currentValue + 1);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: Sizes.p12,
                      color: context.colors.onSurface,
                    ),
                  ),
                  Divider(
                    color: context.colors.surfaceContainerLow,
                    height: 1,
                    thickness: 1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainer,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(Sizes.p4),
                        bottomRight: Radius.circular(Sizes.p4),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        onChanged(max(currentValue - 1, 0));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: Sizes.p12,
                      color: context.colors.onSurface,
                    ),
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
