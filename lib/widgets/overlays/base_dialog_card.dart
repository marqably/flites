import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';

/// A reusable widget that serves as a base for dialog cards.
class BaseDialogCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? backgroundColor;

  const BaseDialogCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
}
