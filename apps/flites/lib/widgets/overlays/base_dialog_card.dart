import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../main.dart';

/// A reusable widget that serves as a base for dialog cards.
class BaseDialogCard extends StatelessWidget {
  const BaseDialogCard({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
  });
  final double? width;
  final double? height;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: Sizes.p16),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p24,
          vertical: Sizes.p16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(Sizes.p16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: Sizes.p12,
              offset: const Offset(0, Sizes.p4),
            ),
          ],
        ),
        child: child,
      );
}
