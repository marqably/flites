import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class CheckboxButton extends StatelessWidget {
  const CheckboxButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.value,
  });

  final VoidCallback? onPressed;
  final String text;
  final Signal<bool> value;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isChecked = value.value;

      return CupertinoButton(
        onPressed: () {
          onPressed?.call();

          value.value = !isChecked;
        },
        child: Row(
          children: [
            Icon(isChecked ? Icons.check_circle : Icons.circle_outlined),
            const SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      );
    });
  }
}
