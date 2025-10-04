import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

class GradientBorderWidget extends StatelessWidget {
  const GradientBorderWidget({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              context.colors.primary,
              context.colors.surface,
            ],
            stops: const [0.0, 0.4],
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
