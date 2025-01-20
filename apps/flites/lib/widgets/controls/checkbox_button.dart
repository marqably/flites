import 'package:flites/main.dart';
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

      return InkWell(
        onTap: () {
          onPressed?.call();

          value.value = !isChecked;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(
                isChecked ? Icons.check_circle : Icons.circle_outlined,
                color: context.colors.surfaceDim,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
