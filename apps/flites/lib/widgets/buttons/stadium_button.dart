import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    required this.text,
    super.key,
    this.onPressed,
    this.color,
    this.height = Sizes.p32,
    this.width = 104,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color ?? context.colors.primary,
            borderRadius: BorderRadius.circular(Sizes.p32),
          ),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.p16,
            ),
          ),
        ),
      );
}
