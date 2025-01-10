import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: icon == null
            ? Text(text)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  Text(
                    text,
                  ),
                ],
              ),
      ),
    );
  }
}
