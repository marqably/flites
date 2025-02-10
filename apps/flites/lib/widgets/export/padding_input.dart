import 'package:flutter/material.dart';
import 'numeric_input_with_buttons.dart';

class PaddingInput extends StatelessWidget {
  final int topPadding;
  final int bottomPadding;
  final int leftPadding;
  final int rightPadding;
  final ValueChanged<int> onTopChanged;
  final ValueChanged<int> onBottomChanged;
  final ValueChanged<int> onLeftChanged;
  final ValueChanged<int> onRightChanged;

  const PaddingInput({
    super.key,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftPadding,
    required this.rightPadding,
    required this.onTopChanged,
    required this.onBottomChanged,
    required this.onLeftChanged,
    required this.onRightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('Padding', style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        SizedBox(
          width: 100,
          child: NumericInputWithButtons(
            currentValue: topPadding,
            onChanged: onTopChanged,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              child: NumericInputWithButtons(
                currentValue: leftPadding,
                onChanged: onLeftChanged,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: NumericInputWithButtons(
                currentValue: rightPadding,
                onChanged: onRightChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 100,
          child: NumericInputWithButtons(
            currentValue: bottomPadding,
            onChanged: onBottomChanged,
          ),
        ),
      ],
    );
  }
}
