import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

class GradientBorderWidget extends StatelessWidget {
  final Widget child;

  const GradientBorderWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            context.colors.primary,
            context.colors.surface,
          ],
          stops: const [0.0, 0.2],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          left: Sizes.p8,
          right: Sizes.p8,
          bottom: Sizes.p8,
        ),
        child: child,
      ),
    );
  }
}
