import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.height = 48,
    this.width = 140,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? context.colors.onSurface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: context.colors.surfaceContainerLowest,
          ),
        ),
      ),
    );
  }
}
